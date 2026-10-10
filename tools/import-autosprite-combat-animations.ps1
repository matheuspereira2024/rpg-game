param()

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -AssemblyName System.Drawing

$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$downloadsRoot = [System.IO.Path]::GetFullPath((Join-Path $env:USERPROFILE 'Downloads'))
$assetsRoot = [System.IO.Path]::GetFullPath((Join-Path $workspaceRoot 'assets\sprites'))
$publicRoot = [System.IO.Path]::GetFullPath((Join-Path $workspaceRoot 'invocacao-web\public\art\arena'))

$packages = @(
  @{ Name = 'Humano Guerreiro'; Zip = 'Humano-Guerreiro-spritesheet.zip'; Asset = 'humano\guerreiro'; Public = 'heroes\humano\guerreiro' },
  @{ Name = 'Humano Bárbaro'; Zip = 'Humano-Barbaro-spritesheet.zip'; Asset = 'humano\barbaro'; Public = 'heroes\humano\barbaro' },
  @{ Name = 'Humano Caçador'; Zip = 'Humano-Ca-ador-spritesheet.zip'; Asset = 'humano\cacador'; Public = 'heroes\humano\cacador' },
  @{ Name = 'Humano Assassino'; Zip = 'Humano-Ladino-spritesheet.zip'; Asset = 'humano\assassino'; Public = 'heroes\humano\assassino' },
  @{ Name = 'Humano Clérigo'; Zip = 'Humano-Cl-rigo-spritesheet.zip'; Asset = 'humano\clerigo'; Public = 'heroes\humano\clerigo'; SourceVersion = 'v2'; ImportedAt = '2026-09-16'; AttackFrames = 16 },
  @{ Name = 'Humano Mago'; Zip = 'Humano-Mago-spritesheet.zip'; Asset = 'humano\mago'; Public = 'heroes\humano\mago' },
  @{ Name = 'Esqueleto Guerreiro'; Zip = 'Skeleto-Guerreiro-spritesheet.zip'; Asset = 'inimigos\esqueleto-guerreiro'; Public = 'enemies\esqueleto-guerreiro' }
)

$directionMap = @{
  'right' = 'east'
  'left' = 'west'
  'up' = 'north'
  'down' = 'south'
  'northeast' = 'north-east'
  'northwest' = 'north-west'
  'southeast' = 'south-east'
  'southwest' = 'south-west'
}

function Assert-WithinRoot([string]$Path, [string]$Root) {
  $resolvedPath = [System.IO.Path]::GetFullPath($Path)
  $resolvedRoot = [System.IO.Path]::GetFullPath($Root).TrimEnd('\') + '\'
  if (-not $resolvedPath.StartsWith($resolvedRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Caminho fora da raiz permitida: $resolvedPath"
  }
}

function Get-State([string]$FolderName) {
  $lower = $FolderName.ToLowerInvariant()
  if ($lower.StartsWith('iso_idle_') -or $lower.StartsWith('idle ')) { return 'idle' }
  if ($lower.StartsWith('iso_walk_') -or $lower.StartsWith('walk ')) { return 'walk' }
  if ($lower.StartsWith('attack ') -or $lower.StartsWith('tiro preciso ') -or $lower.StartsWith('projétil sagrado ') -or $lower.StartsWith('projétil arcano ')) { return 'attack' }
  return $null
}

function Get-Direction([string]$FolderName) {
  $lower = $FolderName.ToLowerInvariant()
  foreach ($key in @('northeast', 'northwest', 'southeast', 'southwest', 'up', 'down', 'right', 'left')) {
    if ($lower.Contains($key)) { return $directionMap[$key] }
  }
  return $null
}

function Remove-StateDirectory([string]$Root, [string]$State) {
  $target = Join-Path $Root $State
  Assert-WithinRoot $target $Root
  if (Test-Path -LiteralPath $target) {
    Remove-Item -LiteralPath $target -Recurse -Force
  }
}

function Save-NormalizedFrame([System.IO.Compression.ZipArchiveEntry]$Entry, [string]$Destination) {
  $stream = $Entry.Open()
  $source = $null
  $target = $null
  try {
    $source = [System.Drawing.Bitmap]::FromStream($stream)
    $target = [System.Drawing.Bitmap]::new(68, 68, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $graphics = [System.Drawing.Graphics]::FromImage($target)
    try {
      $graphics.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceCopy
      $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighSpeed
      $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
      $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
      $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::None
      $graphics.DrawImage($source, [System.Drawing.Rectangle]::new(0, 0, 68, 68), 0, 0, $source.Width, $source.Height, [System.Drawing.GraphicsUnit]::Pixel)
    } finally {
      $graphics.Dispose()
    }
    $target.Save($Destination, [System.Drawing.Imaging.ImageFormat]::Png)
  } finally {
    if ($target) { $target.Dispose() }
    if ($source) { $source.Dispose() }
    $stream.Dispose()
  }
}

foreach ($package in $packages) {
  $assetAnimationRoot = Join-Path (Join-Path $assetsRoot $package.Asset) 'animations'
  $publicAnimationRoot = Join-Path (Join-Path $publicRoot $package.Public) 'animations'
  Assert-WithinRoot $assetAnimationRoot $assetsRoot
  Assert-WithinRoot $publicAnimationRoot $publicRoot
  New-Item -ItemType Directory -Force -Path $assetAnimationRoot, $publicAnimationRoot | Out-Null

  $zipPath = Join-Path $downloadsRoot $package.Zip
  $sourceVersion = if ($package.SourceVersion) { $package.SourceVersion } else { 'v1' }
  $preservedSourcePath = Join-Path $assetAnimationRoot "source-$sourceVersion.zip"
  if (-not (Test-Path -LiteralPath $zipPath -PathType Leaf)) {
    $zipPath = $preservedSourcePath
  }
  if (-not (Test-Path -LiteralPath $zipPath -PathType Leaf)) {
    throw "Pacote não encontrado em Downloads nem na fonte preservada: $($package.Zip)"
  }

  foreach ($state in @('idle', 'walk', 'attack')) {
    Remove-StateDirectory $assetAnimationRoot $state
    Remove-StateDirectory $publicAnimationRoot $state
  }

  $archive = [System.IO.Compression.ZipFile]::OpenRead($zipPath)
  try {
    $frameEntries = @($archive.Entries | Where-Object { $_.FullName -match '/frames/\d+\.png$' })
    $groups = @($frameEntries | Group-Object { ($_.FullName -split '/frames/')[0] })
    $importedGroups = 0
    $importedFrames = 0

    foreach ($group in $groups) {
      $state = Get-State $group.Name
      $direction = Get-Direction $group.Name
      if (-not $state -or -not $direction) { continue }

      $assetDirection = Join-Path (Join-Path $assetAnimationRoot $state) $direction
      New-Item -ItemType Directory -Force -Path $assetDirection | Out-Null
      $orderedEntries = @($group.Group | Sort-Object { [int]([System.IO.Path]::GetFileNameWithoutExtension($_.Name)) })
      $expectedFrames = if ($state -eq 'attack' -and $package.AttackFrames) { $package.AttackFrames } else { 25 }
      if ($orderedEntries.Count -ne $expectedFrames) {
        throw "$($package.Name): $($group.Name) tem $($orderedEntries.Count) quadros; esperado: $expectedFrames."
      }

      for ($index = 0; $index -lt $orderedEntries.Count; $index++) {
        $frameName = 'frame_{0:D3}.png' -f $index
        Save-NormalizedFrame $orderedEntries[$index] (Join-Path $assetDirection $frameName)
        $importedFrames++
      }
      $importedGroups++
    }
  } finally {
    $archive.Dispose()
  }

  $expectedAttackFrames = if ($package.AttackFrames) { $package.AttackFrames } else { 25 }
  $expectedImportedFrames = (16 * 25) + (8 * $expectedAttackFrames)
  if ($importedGroups -ne 24 -or $importedFrames -ne $expectedImportedFrames) {
    throw "$($package.Name): importação incompleta ($importedGroups animações, $importedFrames quadros)."
  }

  foreach ($state in @('idle', 'walk', 'attack')) {
    foreach ($direction in @('north', 'north-east', 'east', 'south-east', 'south', 'south-west', 'west', 'north-west')) {
      $directionPath = Join-Path (Join-Path $assetAnimationRoot $state) $direction
      $directionFrames = @(Get-ChildItem -LiteralPath $directionPath -File -Filter '*.png')
      $expectedFrames = if ($state -eq 'attack') { $expectedAttackFrames } else { 25 }
      if ($directionFrames.Count -ne $expectedFrames) {
        throw "$($package.Name): $state/$direction tem $($directionFrames.Count) quadros; esperado: $expectedFrames."
      }
    }
  }

  if ([System.IO.Path]::GetFullPath($zipPath) -ne [System.IO.Path]::GetFullPath($preservedSourcePath)) {
    Copy-Item -LiteralPath $zipPath -Destination $preservedSourcePath -Force
  }
  $metadata = [ordered]@{
    character = $package.Name
    source_file = $package.Zip
    imported_at = if ($package.ImportedAt) { $package.ImportedAt } else { '2026-09-15' }
    source_frame_size = '256x256'
    runtime_frame_size = '68x68'
    states = @('idle', 'walk', 'attack')
    directions = @('north', 'north-east', 'east', 'south-east', 'south', 'south-west', 'west', 'north-west')
    frames_per_animation = [ordered]@{ idle = 25; walk = 25; attack = $expectedAttackFrames }
    source_duration_seconds = 2.333
    note = if ($package.Name -eq 'Humano Clérigo') { 'Attack usa os 16 quadros de Projétil Sagrado; o projétil viajante é um asset separado na arena.' } else { 'Attack também representa Tiro Preciso e Projétil Arcano nas classes à distância.' }
  }
  $metadata | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $assetAnimationRoot "source-$sourceVersion-metadata.json") -Encoding utf8

  foreach ($state in @('idle', 'walk', 'attack')) {
    Copy-Item -LiteralPath (Join-Path $assetAnimationRoot $state) -Destination $publicAnimationRoot -Recurse -Force
  }

  Write-Output "$($package.Name): 24 animações, $expectedImportedFrames quadros importados."
}
