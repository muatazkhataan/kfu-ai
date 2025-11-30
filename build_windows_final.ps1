# Final script to build Windows app with Visual Studio 2026
# سكريبت نهائي لبناء تطبيق Windows مع Visual Studio 2026

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Building Windows App" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Clean
Write-Host "[1/4] Cleaning project..." -ForegroundColor Yellow
flutter clean
Write-Host ""

# Step 2: Remove old CMake files
Write-Host "[2/4] Removing old CMake files..." -ForegroundColor Yellow
Get-ChildItem -Path "build" -Recurse -Include "CMakeCache.txt","CMakeFiles" -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force
Get-ChildItem -Path "windows" -Recurse -Include "CMakeCache.txt","CMakeFiles" -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force
Write-Host "Done" -ForegroundColor Green
Write-Host ""

# Step 3: Detect Visual Studio and set generator
Write-Host "[3/4] Detecting Visual Studio..." -ForegroundColor Yellow
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

# Step 4: Pre-configure CMake in the build directory
Write-Host "[4/4] Pre-configuring CMake..." -ForegroundColor Yellow

# Create build directory structure
$buildDir = "build\windows\x64\release"
if (-not (Test-Path $buildDir)) {
    New-Item -ItemType Directory -Path $buildDir -Force | Out-Null
}

# Try to configure CMake manually first
Push-Location $buildDir
try {
    Write-Host "Configuring CMake with generator: $cmakeGenerator" -ForegroundColor Cyan
    $cmakeResult = cmake -G "$cmakeGenerator" -A x64 -DCMAKE_BUILD_TYPE=Release ..\..\..\..\windows 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "CMake pre-configured successfully" -ForegroundColor Green
    } else {
        Write-Host "CMake pre-configuration failed, but continuing..." -ForegroundColor Yellow
        Write-Host "Flutter will try to configure it during build" -ForegroundColor Yellow
    }
} catch {
    Write-Host "Error during CMake pre-configuration: $_" -ForegroundColor Yellow
    Write-Host "Continuing with Flutter build..." -ForegroundColor Yellow
} finally {
    Pop-Location
}
Write-Host ""

# Set environment variables for Flutter
$env:CMAKE_GENERATOR = $cmakeGenerator
$env:CMAKE_GENERATOR_PLATFORM = "x64"

# Build with Flutter
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Building with Flutter..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

flutter build windows --release

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "Build completed successfully!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "Build failed" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "If the issue persists, try:" -ForegroundColor Yellow
    Write-Host "1. Update Flutter: flutter upgrade" -ForegroundColor White
    Write-Host "2. Install Visual Studio 2022 alongside Visual Studio 2026" -ForegroundColor White
    Write-Host "3. Check flutter doctor -v for more information" -ForegroundColor White
}

