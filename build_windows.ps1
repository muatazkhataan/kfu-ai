# سكريبت لبناء تطبيق Windows باستخدام Visual Studio الموجود
# Build Windows app using the installed Visual Studio

Write-Host "بناء تطبيق Windows..." -ForegroundColor Cyan
Write-Host "Building Windows app..." -ForegroundColor Cyan
Write-Host ""

# تنظيف المشروع
Write-Host "تنظيف المشروع..." -ForegroundColor Yellow
flutter clean
Write-Host ""

# اكتشاف Visual Studio من flutter doctor
Write-Host "اكتشاف Visual Studio..." -ForegroundColor Yellow
$doctorOutput = flutter doctor -v 2>&1 | Out-String

# تحديد مولد CMake بناءً على Visual Studio الموجود
$cmakeGenerator = "Visual Studio 17 2022"  # افتراضي

if ($doctorOutput -match "Visual Studio.*2026") {
    Write-Host "✓ تم اكتشاف Visual Studio 2026" -ForegroundColor Green
    Write-Host "✓ Visual Studio 2026 detected" -ForegroundColor Green
    # Visual Studio 2026 متوافق مع مولد Visual Studio 17 2022
    $cmakeGenerator = "Visual Studio 17 2022"
} elseif ($doctorOutput -match "Visual Studio.*2022") {
    Write-Host "✓ تم اكتشاف Visual Studio 2022" -ForegroundColor Green
    Write-Host "✓ Visual Studio 2022 detected" -ForegroundColor Green
    $cmakeGenerator = "Visual Studio 17 2022"
} elseif ($doctorOutput -match "Visual Studio.*2019") {
    Write-Host "✓ تم اكتشاف Visual Studio 2019" -ForegroundColor Green
    Write-Host "✓ Visual Studio 2019 detected" -ForegroundColor Green
    $cmakeGenerator = "Visual Studio 16 2019"
}

Write-Host "استخدام مولد CMake: $cmakeGenerator" -ForegroundColor Cyan
Write-Host "Using CMake generator: $cmakeGenerator" -ForegroundColor Cyan
Write-Host ""

# حذف ملفات CMake القديمة
Write-Host "حذف ملفات CMake القديمة..." -ForegroundColor Yellow
Get-ChildItem -Path "build" -Recurse -Include "CMakeCache.txt","CMakeFiles" -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
Get-ChildItem -Path "windows" -Recurse -Include "CMakeCache.txt","CMakeFiles" -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "✓ تم حذف ملفات CMake القديمة" -ForegroundColor Green
Write-Host ""

# تحديد متغيرات البيئة
$env:CMAKE_GENERATOR = $cmakeGenerator
$env:CMAKE_GENERATOR_PLATFORM = "x64"

# بناء المشروع
Write-Host "بدء البناء..." -ForegroundColor Cyan
Write-Host "Starting build..." -ForegroundColor Cyan
Write-Host ""

flutter build windows --release

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "✓ تم البناء بنجاح!" -ForegroundColor Green
    Write-Host "✓ Build completed successfully!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "✗ فشل البناء" -ForegroundColor Red
    Write-Host "✗ Build failed" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
}

