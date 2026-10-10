param([switch]$Force)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$assetsRoot = Join-Path $workspaceRoot 'assets\sprites'
$publicRoot = Join-Path $workspaceRoot 'invocacao-web\public\art\arena'
$markerPath = Join-Path $assetsRoot 'runtime-scale-v1.json'

if ((Test-Path -LiteralPath $markerPath) -and -not $Force) {
  throw 'A padronização runtime-scale-v1 já foi aplicada. Use -Force somente após reimportar os quadros originais.'
}

$units = @(
  @{ Name = 'Humano Guerreiro'; Asset = 'humano\guerreiro'; Public = 'heroes\humano\guerreiro'; Scale = 1.067; SourceBaseline = 57 },
  @{ Name = 'Humano Bárbaro'; Asset = 'humano\barbaro'; Public = 'heroes\humano\barbaro'; Scale = 0.842; SourceBaseline = 62 },
  @{ Name = 'Humano Caçador'; Asset = 'humano\cacador'; Public = 'heroes\humano\cacador'; Scale = 1.200; SourceBaseline = 54 },
  @{ Name = 'Humano Assassino'; Asset = 'humano\assassino'; Public = 'heroes\humano\assassino'; Scale = 1.091; SourceBaseline = 56 },
  @{ Name = 'Humano Clérigo'; Asset = 'humano\clerigo'; Public = 'heroes\humano\clerigo'; Scale = 0.980; SourceBaseline = 57 },
  @{ Name = 'Humano Mago'; Asset = 'humano\mago'; Public = 'heroes\humano\mago'; Scale = 1.067; SourceBaseline = 58 },
  @{ Name = 'Esqueleto Guerreiro'; Asset = 'inimigos\esqueleto-guerreiro'; Public = 'enemies\esqueleto-guerreiro'; Scale = 0.980; SourceBaseline = 56 }
)

$canvasSize = 68
$targetCenterX = 34
$targetBaseline = 58
$processed = 0

foreach ($unit in $units) {
  $animationRoot = Join-Path (Join-Path $assetsRoot $unit.Asset) 'animations'
  $publicAnimationRoot = Join-Path (Join-Path $publicRoot $unit.Public) 'animations'

  foreach ($file in Get-ChildItem -LiteralPath $animationRoot -Recurse -File -Filter 'frame_*.png') {
    $source = [System.Drawing.Bitmap]::FromFile($file.FullName)
    $target = [System.Drawing.Bitmap]::new($canvasSize, $canvasSize, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    try {
      $graphics = [System.Drawing.Graphics]::FromImage($target)
      try {
        $graphics.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceCopy
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
        $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
        $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::None

        $destinationX = [int][math]::Round($targetCenterX - ($targetCenterX * $unit.Scale))
        $destinationY = [int][math]::Round($targetBaseline - ($unit.SourceBaseline * $unit.Scale))
        $destinationSize = [int][math]::Round($canvasSize * $unit.Scale)
        $graphics.DrawImage(
          $source,
          [System.Drawing.Rectangle]::new($destinationX, $destinationY, $destinationSize, $destinationSize),
          0,
          0,
          $canvasSize,
          $canvasSize,
          [System.Drawing.GraphicsUnit]::Pixel
        )
      } finally {
        $graphics.Dispose()
      }

      $temporaryPath = "$($file.FullName).standardized.png"
      $target.Save($temporaryPath, [System.Drawing.Imaging.ImageFormat]::Png)
    } finally {
      $target.Dispose()
      $source.Dispose()
    }

    Move-Item -LiteralPath $temporaryPath -Destination $file.FullName -Force
    $processed++
  }

  foreach ($state in @('idle', 'walk', 'attack')) {
    $publicState = Join-Path $publicAnimationRoot $state
    if (Test-Path -LiteralPath $publicState) {
      Remove-Item -LiteralPath $publicState -Recurse -Force
    }
    Copy-Item -LiteralPath (Join-Path $animationRoot $state) -Destination $publicAnimationRoot -Recurse -Force
  }
}

$metadata = [ordered]@{
  version = 1
  applied_at = '2026-09-16'
  canvas_size = '68x68'
  target_idle_body_height = 48
  target_baseline_y = $targetBaseline
  method = 'One fixed nearest-neighbor scale per unit, applied around a shared horizontal center and foot baseline to every Idle, Walk and Attack frame in all eight directions.'
  units = @($units | ForEach-Object { [ordered]@{ name = $_.Name; scale = $_.Scale; source_baseline_y = $_.SourceBaseline } })
  processed_frames = $processed
}
$metadata | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $markerPath -Encoding utf8

Write-Output "Padronização concluída: $processed quadros em canvas 68x68, corpo Idle de referência com 48 px."
