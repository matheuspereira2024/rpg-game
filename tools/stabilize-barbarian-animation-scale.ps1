param([switch]$Force)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$animationRoot = Join-Path $workspaceRoot 'assets\sprites\humano\barbaro\animations'
$publicAnimationRoot = Join-Path $workspaceRoot 'invocacao-web\public\art\arena\heroes\humano\barbaro\animations'
$metadataPath = Join-Path $animationRoot 'scale-v2-metadata.json'
$targetHeight = 49
$targetBaseline = 58

if ((Test-Path -LiteralPath $metadataPath) -and -not $Force) {
  throw 'A estabilização scale-v2 do Bárbaro já foi aplicada. Use -Force somente depois de reimportar e padronizar novamente os quadros-fonte.'
}

function Get-AlphaBounds([string]$Path) {
  $bitmap = [System.Drawing.Bitmap]::FromFile($Path)
  try {
    $minY = $bitmap.Height
    $maxY = -1
    for ($y = 0; $y -lt $bitmap.Height; $y++) {
      for ($x = 0; $x -lt $bitmap.Width; $x++) {
        if ($bitmap.GetPixel($x, $y).A -gt 8) {
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
  [double]$SourceBaseline
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
      $destinationY = [int][math]::Round($targetBaseline - ($SourceBaseline * $Scale))
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
    $temporaryPath = "$Path.barbarian-scale-v2.png"
    $target.Save($temporaryPath, [System.Drawing.Imaging.ImageFormat]::Png)
  } finally {
    $target.Dispose()
    $source.Dispose()
  }
  Move-Item -LiteralPath $temporaryPath -Destination $Path -Force
}

$groups = @()
$processed = 0
foreach ($state in @('idle', 'walk', 'attack')) {
  $stateRoot = Join-Path $animationRoot $state
  foreach ($direction in Get-ChildItem -LiteralPath $stateRoot -Directory) {
    $files = @(Get-ChildItem -LiteralPath $direction.FullName -File -Filter 'frame_*.png' | Sort-Object Name)
    $bounds = @($files | ForEach-Object { Get-AlphaBounds $_.FullName })
    $medianHeight = Get-Median @($bounds.Height)
    $medianBottom = Get-Median @($bounds.Bottom)
    $scale = $targetHeight / $medianHeight

    foreach ($file in $files) {
      Resize-Frame $file.FullName $scale $medianBottom
      $processed++
    }

    $groups += [ordered]@{
      state = $state
      direction = $direction.Name
      source_median_height = $medianHeight
      source_median_baseline_y = $medianBottom
      relative_scale = [math]::Round($scale, 4)
    }
  }

  $publicState = Join-Path $publicAnimationRoot $state
  if (Test-Path -LiteralPath $publicState) {
    Remove-Item -LiteralPath $publicState -Recurse -Force
  }
  Copy-Item -LiteralPath $stateRoot -Destination $publicAnimationRoot -Recurse -Force
}

$metadata = [ordered]@{
  version = 2
  applied_at = '2026-09-16'
  target_median_height = $targetHeight
  target_baseline_y = $targetBaseline
  canvas_size = '68x68'
  method = 'One fixed nearest-neighbor scale per state and direction; all frames in each group retain their internal motion.'
  processed_frames = $processed
  groups = $groups
}
$metadata | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $metadataPath -Encoding utf8

Write-Output "Bárbaro estabilizado: $processed quadros, mediana-alvo de $targetHeight px e pés em Y=$targetBaseline."
