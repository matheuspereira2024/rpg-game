param([switch]$Force)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$assetsRoot = Join-Path $workspaceRoot 'assets\sprites\humano'
$publicRoot = Join-Path $workspaceRoot 'invocacao-web\public\art\arena\heroes\humano'
$markerPath = Join-Path $assetsRoot 'ranged-animation-scale-v2.json'

if ((Test-Path -LiteralPath $markerPath) -and -not $Force) {
  throw 'A estabilização ranged-animation-scale-v2 já foi aplicada. Use -Force somente após reimportar e padronizar novamente os quadros-fonte.'
}

function Get-AlphaBounds([string]$Path) {
  $bitmap = [System.Drawing.Bitmap]::FromFile($Path)
  try {
    $minX = $bitmap.Width
    $minY = $bitmap.Height
    $maxX = -1
    $maxY = -1
    for ($y = 0; $y -lt $bitmap.Height; $y++) {
      for ($x = 0; $x -lt $bitmap.Width; $x++) {
        if ($bitmap.GetPixel($x, $y).A -gt 8) {
          if ($x -lt $minX) { $minX = $x }
          if ($x -gt $maxX) { $maxX = $x }
          if ($y -lt $minY) { $minY = $y }
          if ($y -gt $maxY) { $maxY = $y }
        }
      }
    }
    return [pscustomobject]@{
      Height = $maxY - $minY + 1
      Bottom = $maxY
    }
  } finally {
    $bitmap.Dispose()
  }
}

function Get-Median([double[]]$Values) {
  $sorted = @($Values | Sort-Object)
  return $sorted[[int][math]::Floor($sorted.Count / 2)]
}

function Resize-Frame(
  [string]$Path,
  [double]$Scale,
  [double]$SourceBaseline,
  [double]$TargetBaseline
) {
  $source = [System.Drawing.Bitmap]::FromFile($Path)
  $target = [System.Drawing.Bitmap]::new(68, 68, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  try {
    $graphics = [System.Drawing.Graphics]::FromImage($target)
    try {
      $graphics.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceCopy
      $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
      $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
      $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::None
      $destinationX = [int][math]::Round(34 - (34 * $Scale))
      $destinationY = [int][math]::Round($TargetBaseline - ($SourceBaseline * $Scale))
      $destinationSize = [int][math]::Round(68 * $Scale)
      $graphics.DrawImage(
        $source,
        [System.Drawing.Rectangle]::new($destinationX, $destinationY, $destinationSize, $destinationSize),
        0,
        0,
        68,
        68,
        [System.Drawing.GraphicsUnit]::Pixel
      )
    } finally {
      $graphics.Dispose()
    }
    $temporaryPath = "$Path.stabilized.png"
    $target.Save($temporaryPath, [System.Drawing.Imaging.ImageFormat]::Png)
  } finally {
    $target.Dispose()
    $source.Dispose()
  }
  Move-Item -LiteralPath $temporaryPath -Destination $Path -Force
}

$walkAdjusted = 0
foreach ($classSlug in @('cacador', 'assassino')) {
  $walkRoot = Join-Path (Join-Path $assetsRoot $classSlug) 'animations\walk'
  foreach ($direction in Get-ChildItem -LiteralPath $walkRoot -Directory) {
    $files = @(Get-ChildItem -LiteralPath $direction.FullName -File -Filter 'frame_*.png' | Sort-Object Name)
    $bounds = @($files | ForEach-Object { Get-AlphaBounds $_.FullName })
    $targetHeight = Get-Median @($bounds.Height)

    for ($index = 0; $index -lt $files.Count; $index++) {
      $previousIndex = if ($index -eq 0) { $files.Count - 1 } else { $index - 1 }
      $nextIndex = if ($index -eq $files.Count - 1) { 0 } else { $index + 1 }
      $localMedianBottom = Get-Median @(
        $bounds[$previousIndex].Bottom,
        $bounds[$index].Bottom,
        $bounds[$nextIndex].Bottom
      )
      $targetBottom = if ([math]::Abs($bounds[$index].Bottom - $localMedianBottom) -gt 1) {
        $localMedianBottom
      } else {
        $bounds[$index].Bottom
      }
      $scale = $targetHeight / $bounds[$index].Height
      Resize-Frame $files[$index].FullName $scale $bounds[$index].Bottom $targetBottom
      $walkAdjusted++
    }
  }
}

$loopCorrections = 0
foreach ($classSlug in @('cacador', 'assassino')) {
  $walkRoot = Join-Path (Join-Path $assetsRoot $classSlug) 'animations\walk'
  foreach ($direction in Get-ChildItem -LiteralPath $walkRoot -Directory) {
    $files = @(Get-ChildItem -LiteralPath $direction.FullName -File -Filter 'frame_*.png' | Sort-Object Name)
    $firstBounds = Get-AlphaBounds $files[0].FullName
    $lastBounds = Get-AlphaBounds $files[-1].FullName
    if ([math]::Abs($firstBounds.Bottom - $lastBounds.Bottom) -gt 1) {
      Resize-Frame $files[-1].FullName 1 $lastBounds.Bottom $firstBounds.Bottom
      $loopCorrections++
    }
  }
}

$hunterAttackRoot = Join-Path $assetsRoot 'cacador\animations\attack'
$attackAdjusted = 0
foreach ($direction in Get-ChildItem -LiteralPath $hunterAttackRoot -Directory) {
  $files = @(Get-ChildItem -LiteralPath $direction.FullName -File -Filter 'frame_*.png' | Sort-Object Name)
  $bounds = @($files | ForEach-Object { Get-AlphaBounds $_.FullName })
  $sourceBaseline = Get-Median @($bounds.Bottom)
  foreach ($file in $files) {
    Resize-Frame $file.FullName 0.92 $sourceBaseline 57
    $attackAdjusted++
  }
}

foreach ($classSlug in @('cacador', 'assassino')) {
  $assetAnimationRoot = Join-Path (Join-Path $assetsRoot $classSlug) 'animations'
  $publicAnimationRoot = Join-Path (Join-Path $publicRoot $classSlug) 'animations'
  foreach ($state in @('walk', 'attack')) {
    if ($classSlug -eq 'assassino' -and $state -eq 'attack') { continue }
    $publicState = Join-Path $publicAnimationRoot $state
    if (Test-Path -LiteralPath $publicState) {
      Remove-Item -LiteralPath $publicState -Recurse -Force
    }
    Copy-Item -LiteralPath (Join-Path $assetAnimationRoot $state) -Destination $publicAnimationRoot -Recurse -Force
  }
}

$metadata = [ordered]@{
  version = 2
  applied_at = '2026-09-16'
  walk = [ordered]@{
    units = @('Humano Caçador', 'Humano Assassino')
    method = 'Per-direction median opaque height; abrupt baseline outliers are replaced by the circular three-frame median.'
    adjusted_frames = $walkAdjusted
    loop_closure_corrections = $loopCorrections
  }
  hunter_attack = [ordered]@{
    relative_scale = 0.92
    target_baseline_y = 57
    adjusted_frames = $attackAdjusted
  }
}
$metadata | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $markerPath -Encoding utf8

Write-Output "Estabilização concluída: $walkAdjusted quadros de Walk, $loopCorrections fechamentos de loop e $attackAdjusted quadros de Attack do Caçador."
