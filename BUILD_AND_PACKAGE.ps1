# Complete script: Build and package Windows app
# سكريبت كامل: بناء وتغليف تطبيق Windows

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Build and Package Windows App" -ForegroundColor Cyan
Write-Host "بناء وتغليف تطبيق Windows" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Precache Windows engine files
Write-Host "[1/3] Precaching Windows engine files..." -ForegroundColor Yellow
$env:FLUTTER_STORAGE_BASE_URL = "https://storage.googleapis.com"
$env:PUB_HOSTED_URL = "https://pub.dev"
flutter precache --windows --force
Write-Host ""

# Step 2: Build
Write-Host "[2/3] Building Windows application..." -ForegroundColor Yellow
$env:FLUTTER_STORAGE_BASE_URL = "https://storage.flutter-io.cn"
$env:PUB_HOSTED_URL = "https://pub.flutter-io.cn"
flutter build windows --release

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed!" -ForegroundColor Red
    exit 1
}

Write-Host "Build completed successfully!" -ForegroundColor Green
Write-Host ""

# Step 3: Package
Write-Host "[3/3] Packaging application..." -ForegroundColor Yellow
.\package_windows.ps1

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "All done!" -ForegroundColor Green
Write-Host "تم الانتهاء!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green












