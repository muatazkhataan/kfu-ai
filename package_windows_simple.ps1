# Simple script to package Windows app (assumes already built)
# سكريبت بسيط لتغليف تطبيق Windows (يفترض أنه تم بناؤه مسبقاً)

param(
    [string]$OutputDir = "dist",
    [string]$Version = "1.0.1"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Packaging Windows Application" -ForegroundColor Cyan
Write-Host "تغليف تطبيق Windows" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Locate release files
$releaseDir = "build\windows\x64\runner\Release"

if (-not (Test-Path $releaseDir)) {
    Write-Host "Release directory not found: $releaseDir" -ForegroundColor Red
    Write-Host "Please build the app first: flutter build windows --release" -ForegroundColor Yellow
    exit 1
}

Write-Host "Release directory found: $releaseDir" -ForegroundColor Green
Write-Host ""

# Create output directory
$packageName = "kfu_ai_windows_$Version"
$packageDir = "$OutputDir\$packageName"

if (Test-Path $packageDir) {
    Remove-Item $packageDir -Recurse -Force
}
New-Item -ItemType Directory -Path $packageDir -Force | Out-Null
Write-Host "Package directory: $packageDir" -ForegroundColor Green
Write-Host ""

# Copy all files
Write-Host "Copying files..." -ForegroundColor Yellow

# Copy executable
$exeFile = Get-ChildItem $releaseDir -Filter "*.exe" | Where-Object { $_.Name -eq "kfu_ai.exe" }
if ($exeFile) {
    Copy-Item $exeFile.FullName -Destination $packageDir
    Write-Host "Copied: $($exeFile.Name)" -ForegroundColor Green
} else {
    Write-Host "Executable not found!" -ForegroundColor Red
    exit 1
}

# Copy all DLLs
$dllCount = 0
Get-ChildItem $releaseDir -Filter "*.dll" | ForEach-Object {
    Copy-Item $_.FullName -Destination $packageDir
    $dllCount++
}
Write-Host "Copied: $dllCount DLL files" -ForegroundColor Green

# Copy data directory
$dataDir = Join-Path $releaseDir "data"
if (Test-Path $dataDir) {
    Copy-Item $dataDir -Destination $packageDir -Recurse
    Write-Host "Copied: data directory (contains fonts and assets)" -ForegroundColor Green
    
    # Verify fonts
    $flutterAssetsDir = Join-Path $packageDir "data\flutter_assets"
    if (Test-Path $flutterAssetsDir) {
        $fontFiles = Get-ChildItem $flutterAssetsDir -Recurse -Filter "*.ttf","*.otf"
        Write-Host "Fonts included: $($fontFiles.Count) files" -ForegroundColor Green
        
        $imageFiles = Get-ChildItem $flutterAssetsDir -Recurse -Filter "*.png","*.jpg","*.svg"
        Write-Host "Images/icons included: $($imageFiles.Count) files" -ForegroundColor Green
    }
}

# Copy native_assets if exists
$nativeAssetsDir = Join-Path $releaseDir "native_assets"
if (Test-Path $nativeAssetsDir) {
    Copy-Item $nativeAssetsDir -Destination $packageDir -Recurse
    Write-Host "Copied: native_assets directory" -ForegroundColor Green
}

Write-Host ""

# Create README
$readmeLines = @(
    "# KFU AI Assistant",
    "Version: $Version",
    "",
    "## System Requirements",
    "- Windows 10 or later (64-bit)",
    "- No need to install Flutter or Dart",
    "- No additional software required",
    "",
    "## Installation",
    "1. Extract all files from this folder",
    "2. Run kfu_ai.exe",
    "3. Do not delete any files from the folder",
    "",
    "## Contents",
    "- kfu_ai.exe: Main application",
    "- *.dll: Required libraries",
    "- data/: Data, fonts, and icons",
    "",
    "## Notes",
    "- All fonts and icons are included in the folder",
    "- Application works independently",
    "",
    "---",
    "KFU AI Assistant - Windows Package",
    "Version: $Version",
    ("Build Date: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss"))
)
$readmeContent = $readmeLines -join "`r`n"

$readmeContent | Out-File -FilePath "$packageDir\README.txt" -Encoding UTF8
Write-Host "Created: README.txt" -ForegroundColor Green

# Create version info
$versionInfo = @{
    Version = $Version
    BuildDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Platform = "Windows x64"
} | ConvertTo-Json

$versionInfo | Out-File -FilePath "$packageDir\version.json" -Encoding UTF8
Write-Host "Created: version.json" -ForegroundColor Green
Write-Host ""

# Summary
$packageSize = [math]::Round((Get-ChildItem $packageDir -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB, 2)

Write-Host "========================================" -ForegroundColor Green
Write-Host "Package created successfully!" -ForegroundColor Green
Write-Host "تم إنشاء النسخة بنجاح!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Package location: $packageDir" -ForegroundColor Cyan
Write-Host "Package size: $packageSize MB" -ForegroundColor Cyan
Write-Host ""

# Create ZIP file
Write-Host "Creating ZIP archive..." -ForegroundColor Yellow
$zipFile = "$OutputDir\$packageName.zip"
if (Test-Path $zipFile) {
    Remove-Item $zipFile -Force
}

Compress-Archive -Path $packageDir -DestinationPath $zipFile -Force
Write-Host "ZIP created: $zipFile" -ForegroundColor Green

$zipSizeMB = [math]::Round((Get-Item $zipFile).Length / 1MB, 2)
Write-Host ("ZIP size: " + $zipSizeMB + " MB") -ForegroundColor Green
Write-Host ""
Write-Host "Package is ready for distribution!" -ForegroundColor Green
Write-Host "النسخة جاهزة للتوزيع!" -ForegroundColor Green

