# Create Windows distributable package
# إنشاء نسخة قابلة للتوزيع على Windows

param(
    [string]$OutputDir = "dist",
    [string]$Version = "1.0.1"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Creating Windows Package" -ForegroundColor Cyan
Write-Host "إنشاء نسخة Windows للتوزيع" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Build the application
Write-Host "[1/5] Building Windows application..." -ForegroundColor Yellow
Write-Host "[1/5] بناء تطبيق Windows..." -ForegroundColor Yellow

# Use Chinese mirror if needed
$env:FLUTTER_STORAGE_BASE_URL = "https://storage.flutter-io.cn"
$env:PUB_HOSTED_URL = "https://pub.flutter-io.cn"

flutter build windows --release

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed!" -ForegroundColor Red
    exit 1
}

Write-Host "Build completed successfully" -ForegroundColor Green
Write-Host ""

# Step 2: Locate release files
Write-Host "[2/5] Locating release files..." -ForegroundColor Yellow
$releaseDir = "build\windows\x64\runner\Release"

if (-not (Test-Path $releaseDir)) {
    Write-Host "Release directory not found: $releaseDir" -ForegroundColor Red
    exit 1
}

Write-Host "Release directory: $releaseDir" -ForegroundColor Green
Write-Host ""

# Step 3: Create output directory
Write-Host "[3/5] Creating output directory..." -ForegroundColor Yellow
$packageName = "kfu_ai_windows_$Version"
$packageDir = "$OutputDir\$packageName"

if (Test-Path $packageDir) {
    Remove-Item $packageDir -Recurse -Force
}
New-Item -ItemType Directory -Path $packageDir -Force | Out-Null
Write-Host "Package directory: $packageDir" -ForegroundColor Green
Write-Host ""

# Step 4: Copy all required files
Write-Host "[4/5] Copying files..." -ForegroundColor Yellow

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
Get-ChildItem $releaseDir -Filter "*.dll" | ForEach-Object {
    Copy-Item $_.FullName -Destination $packageDir
    Write-Host "Copied: $($_.Name)" -ForegroundColor Green
}

# Copy data directory (contains fonts, assets, etc.)
$dataDir = Join-Path $releaseDir "data"
if (Test-Path $dataDir) {
    Copy-Item $dataDir -Destination $packageDir -Recurse
    Write-Host "Copied: data directory (contains fonts and assets)" -ForegroundColor Green
}

# Copy native_assets if exists
$nativeAssetsDir = Join-Path $releaseDir "native_assets"
if (Test-Path $nativeAssetsDir) {
    Copy-Item $nativeAssetsDir -Destination $packageDir -Recurse
    Write-Host "Copied: native_assets directory" -ForegroundColor Green
}

# Verify fonts are included
$flutterAssetsDir = Join-Path $packageDir "data\flutter_assets"
if (Test-Path $flutterAssetsDir) {
    $fontFiles = Get-ChildItem $flutterAssetsDir -Recurse -Filter "*.ttf","*.otf" | Measure-Object
    Write-Host "Fonts included: $($fontFiles.Count) files" -ForegroundColor Green
}

Write-Host ""

# Step 5: Create README and package info
Write-Host "[5/5] Creating package documentation..." -ForegroundColor Yellow

$readmeContent = @"
# مساعد كفو - KFU AI Assistant
Version: $Version

## متطلبات النظام
- Windows 10 أو أحدث (64-bit)
- لا حاجة لتثبيت Flutter أو Dart
- لا حاجة لتثبيت أي برامج إضافية

## التثبيت
1. استخرج جميع الملفات من هذا المجلد
2. شغّل kfu_ai.exe
3. لا تحذف أي ملف من المجلد

## المحتويات
- kfu_ai.exe: التطبيق الرئيسي
- *.dll: المكتبات المطلوبة
- data/: البيانات والخطوط والأيقونات

## ملاحظات
- جميع الخطوط والأيقونات مضمّنة في المجلد
- التطبيق يعمل بشكل مستقل بدون اتصال بالإنترنت (بعد التثبيت الأولي)
- للتحديثات، قم بتحميل النسخة الجديدة واستبدل الملفات

## الدعم
للمساعدة والدعم، يرجى التواصل مع فريق التطوير.

---
KFU AI Assistant - Windows Package
Version: $Version
Build Date: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
"@

$readmeContent | Out-File -FilePath "$packageDir\README.txt" -Encoding UTF8
Write-Host "Created: README.txt" -ForegroundColor Green

# Create version info
$versionInfo = @{
    Version = $Version
    BuildDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Platform = "Windows x64"
    FlutterVersion = (flutter --version 2>&1 | Select-String "Flutter" | Select-Object -First 1).ToString()
} | ConvertTo-Json

$versionInfo | Out-File -FilePath "$packageDir\version.json" -Encoding UTF8
Write-Host "Created: version.json" -ForegroundColor Green
Write-Host ""

# Summary
Write-Host "========================================" -ForegroundColor Green
Write-Host "Package created successfully!" -ForegroundColor Green
Write-Host "تم إنشاء النسخة بنجاح!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Package location: $packageDir" -ForegroundColor Cyan
$packageSize = [math]::Round((Get-ChildItem $packageDir -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB, 2)
Write-Host "Package size: $packageSize MB" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Test the package on a different Windows machine" -ForegroundColor White
Write-Host "2. Create a ZIP file for distribution" -ForegroundColor White
Write-Host "3. Optionally create an installer using Inno Setup or WiX" -ForegroundColor White
Write-Host ""

# Create ZIP file
Write-Host "Creating ZIP archive..." -ForegroundColor Yellow
$zipFile = "$OutputDir\$packageName.zip"
if (Test-Path $zipFile) {
    Remove-Item $zipFile -Force
}

Compress-Archive -Path $packageDir -DestinationPath $zipFile -Force
Write-Host ("ZIP created: " + $zipFile) -ForegroundColor Green
$zipSizeMB = [math]::Round((Get-Item $zipFile).Length / 1MB, 2)
Write-Host ('ZIP size: ' + $zipSizeMB + ' MB') -ForegroundColor Green

