# Build Windows app with manual CMake configuration
# بناء تطبيق Windows مع تكوين CMake يدوي

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

# Create build directory
$buildDir = "build\windows\x64\release"
if (-not (Test-Path $buildDir)) {
    New-Item -ItemType Directory -Path $buildDir -Force | Out-Null
}

# Configure CMake manually
Write-Host "Configuring CMake..." -ForegroundColor Yellow
Push-Location $buildDir
try {
    cmake -G "$cmakeGenerator" -A x64 -DCMAKE_BUILD_TYPE=Release ..\..\..\..\windows
    if ($LASTEXITCODE -ne 0) {
        Write-Host "CMake configuration failed" -ForegroundColor Red
        Pop-Location
        exit 1
    }
    Write-Host "CMake configured successfully" -ForegroundColor Green
} catch {
    Write-Host "Error configuring CMake: $_" -ForegroundColor Red
    Pop-Location
    exit 1
} finally {
    Pop-Location
}
Write-Host ""

# Set environment variables
$env:CMAKE_GENERATOR = $cmakeGenerator
$env:CMAKE_GENERATOR_PLATFORM = "x64"

# Build with Flutter
Write-Host "Building with Flutter..." -ForegroundColor Cyan
flutter build windows --release

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "Build completed successfully!" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "Build failed" -ForegroundColor Red
}

