param(
    [ValidateSet('Release', 'Debug')]
    [string]$Configuration = 'Release',
    [string]$SdkPath,
    [string]$MSBuildPath,
    [string]$WindowsSdkVersion
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
if (-not $SdkPath) {
    if ($env:BRX27_SDK_PATH) {
        $SdkPath = $env:BRX27_SDK_PATH
    } else {
        $programFiles64 = if ($env:ProgramW6432) { $env:ProgramW6432 } else { $env:ProgramFiles }
        $SdkPath = Join-Path $programFiles64 'Bricsys\BRXSDK\BRX27.1.05.0'
    }
}
$SdkPath = (Resolve-Path -LiteralPath $SdkPath).Path
foreach ($relativePath in @('inc\arxHeaders.h', 'lib64\brx27.lib')) {
    if (-not (Test-Path -LiteralPath (Join-Path $SdkPath $relativePath))) {
        throw "SDK V27 incompleto: falta $relativePath em $SdkPath"
    }
}

if (-not $MSBuildPath) {
    $vswhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\Installer\vswhere.exe'
    if (Test-Path -LiteralPath $vswhere) {
        $MSBuildPath = & $vswhere -latest -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -find 'MSBuild\**\Bin\MSBuild.exe' | Select-Object -First 1
        if (-not $MSBuildPath) {
            # An interrupted installer can leave usable build tools in an
            # instance excluded by the default vswhere completeness filter.
            $instances = & $vswhere -all -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
            foreach ($instance in $instances) {
                $candidate = Join-Path $instance 'MSBuild\Current\Bin\MSBuild.exe'
                if (Test-Path -LiteralPath $candidate) {
                    Write-Warning 'Instalacao do Visual Studio registrada como incompleta; tentando as ferramentas presentes. Componentes ausentes serao informados pelo MSBuild.'
                    $MSBuildPath = $candidate
                    break
                }
            }
        }
    }
    if (-not $MSBuildPath) {
        $command = Get-Command MSBuild.exe -ErrorAction SilentlyContinue
        if ($command) { $MSBuildPath = $command.Source }
    }
}
if (-not $MSBuildPath -or -not (Test-Path -LiteralPath $MSBuildPath)) {
    throw 'MSBuild C++ nao encontrado. Instale Visual Studio 2022 ou Build Tools com MSVC v143 x64/x86, ATL, MFC e Windows SDK 10.0.19041.0. Depois execute este script novamente.'
}

$project = Join-Path $projectRoot 'source\DOSLib.vcxproj'
if (-not $WindowsSdkVersion) {
    $kitsRoot = Join-Path ${env:ProgramFiles(x86)} 'Windows Kits\10'
    $sdkIncludes = Join-Path $kitsRoot 'Include'
    if (-not (Test-Path -LiteralPath (Join-Path $sdkIncludes '10.0.19041.0\um\Windows.h'))) {
        $installedSdks = Get-ChildItem -LiteralPath $sdkIncludes -Directory -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -match '^10\.0\.\d+\.\d+$' } |
            Sort-Object { [version]$_.Name } -Descending
        foreach ($sdk in $installedSdks) {
            $sdkFiles = @(
                "Include\$($sdk.Name)\um\Windows.h",
                "Include\$($sdk.Name)\ucrt\stdio.h",
                "Lib\$($sdk.Name)\um\x64\kernel32.lib",
                "Lib\$($sdk.Name)\ucrt\x64\ucrt.lib",
                "bin\$($sdk.Name)\x64\rc.exe"
            )
            $missingFiles = @($sdkFiles | Where-Object { -not (Test-Path -LiteralPath (Join-Path $kitsRoot $_)) })
            if ($missingFiles.Count -eq 0) {
                $WindowsSdkVersion = $sdk.Name
                Write-Output "Windows SDK 10.0.19041.0 ausente; usando SDK instalado $WindowsSdkVersion. Validacao no CAD ainda necessaria."
                break
            }
        }
    }
}
$buildArguments = @(
    $project,
    '/m',
    '/t:Build',
    "/p:Configuration=${Configuration}_BRX27",
    '/p:Platform=x64',
    "/p:Brx27SdkDir=$SdkPath",
    '/nologo'
)
if ($WindowsSdkVersion) {
    $buildArguments += "/p:WindowsTargetPlatformVersion=$WindowsSdkVersion"
}
& $MSBuildPath @buildArguments
if ($LASTEXITCODE -ne 0) { throw "A compilacao falhou (MSBuild: $LASTEXITCODE)." }
$output = Join-Path $projectRoot "bin\$Configuration\brx\DOSLib27x64.brx"
if (-not (Test-Path -LiteralPath $output)) { throw "MSBuild terminou sem gerar $output" }
Write-Output "Compilado: $output"
Write-Output 'Validacao de carregamento e das funcoes dos_* no BricsCAD V27 ainda necessaria.'
