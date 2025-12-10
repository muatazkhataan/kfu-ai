# Fix Flutter Windows build error MSB8066
# حل خطأ بناء Flutter Windows MSB8066

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Fixing Flutter Windows Build Error" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Clean everything
Write-Host "[1/4] Cleaning project..." -ForegroundColor Yellow
flutter clean
Write-Host ""

# Step 2: Remove all build artifacts
Write-Host "[2/4] Removing build artifacts..." -ForegroundColor Yellow
if (Test-Path "build") {
    Remove-Item "build" -Recurse -Force
    Write-Host "Removed build directory" -ForegroundColor Green
}

Get-ChildItem -Path "." -Recurse -Include "CMakeCache.txt","CMakeFiles" -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Removed CMake files" -ForegroundColor Green
Write-Host ""

# Step 3: Get dependencies
Write-Host "[3/4] Getting dependencies..." -ForegroundColor Yellow
flutter pub get
Write-Host ""

# Step 4: Try building with different approaches
Write-Host "[4/4] Attempting to build..." -ForegroundColor Yellow

# Set environment variables
$env:FLUTTER_STORAGE_BASE_URL = "https://storage.flutter-io.cn"
$env:PUB_HOSTED_URL = "https://pub.flutter-io.cn"

# Try building
Write-Host "Building Windows release..." -ForegroundColor Cyan
flutter build windows --release

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "Build successful!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "Build failed" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Possible solutions:" -ForegroundColor Yellow
    Write-Host "1. Enable Developer Mode in Windows Settings" -ForegroundColor White
    Write-Host "2. Run PowerShell as Administrator" -ForegroundColor White
    Write-Host "3. Check Visual Studio installation" -ForegroundColor White
    Write-Host "4. Try: flutter upgrade" -ForegroundColor White
    Write-Host "5. Check if antivirus is blocking the build" -ForegroundColor White
}












