param(
    [ValidatePattern('^[0-9A-Za-z][0-9A-Za-z._-]*$')]
    [string]$Version = '9.1.2-brx27.1'
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
$binary = Join-Path $projectRoot 'bin\Release\brx\DOSLib27x64.brx'
if (-not (Test-Path -LiteralPath $binary)) { throw 'Compile Release_BRX27 antes de criar o pacote.' }
$revision = & git -C $projectRoot rev-parse HEAD
if ($LASTEXITCODE -ne 0) { throw 'O pacote precisa de um commit Git de origem.' }
$dirty = & git -C $projectRoot status --porcelain --untracked-files=normal
if ($LASTEXITCODE -ne 0) { throw 'Falha ao consultar o estado Git.' }
if ($dirty) { throw 'Registre as alteracoes no Git antes de gerar o pacote publicavel.' }

$artifacts = Join-Path $projectRoot 'artifacts'
$packageName = "DOSLib-Community-$Version-Windows-x64"
$staging = Join-Path $artifacts ('staging\' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $staging -Force | Out-Null
Copy-Item -LiteralPath $binary -Destination (Join-Path $staging 'DOSLib27x64.brx')
foreach ($file in @('LICENSE', 'ACKNOWLEDGMENTS.md', 'README.md', 'README.pt-BR.md', 'BRX27_IDCAD.md', 'CHANGELOG.md', 'CONTRIBUTING.md')) {
    Copy-Item -LiteralPath (Join-Path $projectRoot $file) -Destination (Join-Path $staging $file)
}
# Keep relative documentation links valid inside the archive.
Copy-Item -LiteralPath (Join-Path $projectRoot 'docs') -Destination (Join-Path $staging 'docs') -Recurse
$buildInfo = @(
    'DOSLib-Community',
    "Package: $Version (initial community test candidate)",
    'Target: BricsCAD V27 / Windows x64 / Release_BRX27',
    "Source commit: $revision",
    'Library version: 9.1.2; expected (dos_version): (9 1 2)',
    'See CHANGELOG.md and BRX27_IDCAD.md for build environment and reported runtime checks.',
    'Packaging records the source revision; rebuild first when source changes.',
    'Full function regression and other environments remain unverified.'
)
[IO.File]::WriteAllLines((Join-Path $staging 'BUILD_INFO.txt'), $buildInfo, [Text.UTF8Encoding]::new($false))
$sums = Get-ChildItem -LiteralPath $staging -File -Recurse | Sort-Object FullName | ForEach-Object {
    $relative = $_.FullName.Substring($staging.Length + 1).Replace('\', '/')
    $hash = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
    "$hash  $relative"
}
[IO.File]::WriteAllLines((Join-Path $staging 'SHA256SUMS.txt'), $sums, [Text.UTF8Encoding]::new($false))
$zip = Join-Path $artifacts "$packageName.zip"
Compress-Archive -Path (Join-Path $staging '*') -DestinationPath $zip -Force
$zipHash = (Get-FileHash -LiteralPath $zip -Algorithm SHA256).Hash.ToLowerInvariant()
$zipSum = Join-Path $artifacts "$packageName.zip.sha256"
[IO.File]::WriteAllText($zipSum, "$zipHash  $packageName.zip`n", [Text.UTF8Encoding]::new($false))
Write-Output "Pacote: $zip"
Write-Output "Checksum: $zipSum"
