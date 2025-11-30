# Simple script to build Windows app
# سكريبت بسيط لبناء تطبيق Windows

Write-Host "Building Windows app..." -ForegroundColor Cyan
Write-Host ""

# Clean
flutter clean

# Remove old CMake files
Get-ChildItem -Path "build" -Recurse -Include "CMakeCache.txt","CMakeFiles" -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force
Get-ChildItem -Path "windows" -Recurse -Include "CMakeCache.txt","CMakeFiles" -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force

# Detect Visual Studio
$doctorOutput = flutter doctor -v 2>&1 | Out-String
$cmakeGenerator = "Visual Studio 17 2022"

if ($doctorOutput -match "Visual Studio.*2026") {
    $cmakeGenerator = "Visual Studio 17 2022"
    Write-Host "Visual Studio 2026 detected - using Visual Studio 17 2022 generator" -ForegroundColor Green
} elseif ($doctorOutput -match "Visual Studio.*2022") {
    $cmakeGenerator = "Visual Studio 17 2022"
    Write-Host "Visual Studio 2022 detected" -ForegroundColor Green
} elseif ($doctorOutput -match "Visual Studio.*2019") {
    $cmakeGenerator = "Visual Studio 16 2019"
    Write-Host "Visual Studio 2019 detected" -ForegroundColor Green
}

Write-Host "CMake Generator: $cmakeGenerator" -ForegroundColor Cyan
Write-Host ""

# Set environment variables
$env:CMAKE_GENERATOR = $cmakeGenerator
$env:CMAKE_GENERATOR_PLATFORM = "x64"

# Build
flutter build windows --release
