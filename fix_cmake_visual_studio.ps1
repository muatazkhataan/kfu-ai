# سكريبت لحل مشكلة CMake و Visual Studio في Flutter Windows
# Fix CMake and Visual Studio issues for Flutter Windows builds

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "حل مشكلة CMake و Visual Studio" -ForegroundColor Cyan
Write-Host "Fix CMake and Visual Studio Issues" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# الخطوة 1: تنظيف المشروع
Write-Host "[1/4] تنظيف المشروع..." -ForegroundColor Yellow
Write-Host "[1/4] Cleaning project..." -ForegroundColor Yellow
flutter clean
Write-Host "✓ تم التنظيف" -ForegroundColor Green
Write-Host ""

# الخطوة 2: حذف ملفات CMake القديمة
Write-Host "[2/4] حذف ملفات CMake القديمة..." -ForegroundColor Yellow
Write-Host "[2/4] Removing old CMake files..." -ForegroundColor Yellow
$cmakeFiles = Get-ChildItem -Path "windows" -Recurse -Include "CMakeCache.txt","CMakeFiles" -ErrorAction SilentlyContinue
if ($cmakeFiles) {
    $cmakeFiles | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "✓ تم حذف ملفات CMake القديمة" -ForegroundColor Green
} else {
    Write-Host "✓ لا توجد ملفات CMake قديمة" -ForegroundColor Green
}
Write-Host ""

# الخطوة 3: التحقق من Visual Studio واكتشاف الإصدار
Write-Host "[3/5] التحقق من Visual Studio واكتشاف الإصدار..." -ForegroundColor Yellow
Write-Host "[3/5] Checking Visual Studio and detecting version..." -ForegroundColor Yellow
$vsPath1 = "C:\Program Files\Microsoft Visual Studio"
$vsPath2 = "C:\Program Files (x86)\Microsoft Visual Studio"
$vsInstalled = $false
$vsVersion = $null
$cmakeGenerator = $null

# خريطة إصدارات Visual Studio إلى مولدات CMake
# Visual Studio 2019 = 16, 2022 = 17, 2026 = 18
$vsVersionMap = @{
    "2019" = "Visual Studio 16 2019"
    "2022" = "Visual Studio 17 2022"
    "2026" = "Visual Studio 18 2026"
}

# البحث عن Visual Studio
if (Test-Path $vsPath1) {
    $vsFolders = Get-ChildItem $vsPath1 -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match "^\d+$" }
    if ($vsFolders) {
        foreach ($folder in $vsFolders) {
            $versionNum = [int]$folder.Name
            if ($versionNum -eq 16) {
                $vsVersion = "2019"
                $cmakeGenerator = $vsVersionMap["2019"]
            } elseif ($versionNum -eq 17) {
                $vsVersion = "2022"
                $cmakeGenerator = $vsVersionMap["2022"]
            } elseif ($versionNum -eq 18) {
                $vsVersion = "2026"
                $cmakeGenerator = $vsVersionMap["2026"]
            }
            
            if ($vsVersion) {
                Write-Host "✓ تم العثور على Visual Studio $vsVersion في: $($folder.FullName)" -ForegroundColor Green
                Write-Host "✓ Found Visual Studio $vsVersion at: $($folder.FullName)" -ForegroundColor Green
                $vsInstalled = $true
                break
            }
        }
    }
}

if (-not $vsInstalled -and (Test-Path $vsPath2)) {
    $vsFolders = Get-ChildItem $vsPath2 -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match "^\d+$" }
    if ($vsFolders) {
        foreach ($folder in $vsFolders) {
            $versionNum = [int]$folder.Name
            if ($versionNum -eq 16) {
                $vsVersion = "2019"
                $cmakeGenerator = $vsVersionMap["2019"]
            } elseif ($versionNum -eq 17) {
                $vsVersion = "2022"
                $cmakeGenerator = $vsVersionMap["2022"]
            } elseif ($versionNum -eq 18) {
                $vsVersion = "2026"
                $cmakeGenerator = $vsVersionMap["2026"]
            }
            
            if ($vsVersion) {
                Write-Host "✓ تم العثور على Visual Studio $vsVersion في: $($folder.FullName)" -ForegroundColor Green
                Write-Host "✓ Found Visual Studio $vsVersion at: $($folder.FullName)" -ForegroundColor Green
                $vsInstalled = $true
                break
            }
        }
    }
}

# محاولة استخدام flutter doctor للكشف
if (-not $vsInstalled) {
    Write-Host "محاولة الكشف باستخدام flutter doctor..." -ForegroundColor Yellow
    Write-Host "Trying to detect using flutter doctor..." -ForegroundColor Yellow
    $doctorOutput = flutter doctor -v 2>&1 | Out-String
    if ($doctorOutput -match "Visual Studio.*(\d{4})") {
        $detectedYear = $matches[1]
        if ($detectedYear -eq "2019") {
            $vsVersion = "2019"
            $cmakeGenerator = $vsVersionMap["2019"]
        } elseif ($detectedYear -eq "2022") {
            $vsVersion = "2022"
            $cmakeGenerator = $vsVersionMap["2022"]
        } elseif ($detectedYear -eq "2026") {
            $vsVersion = "2026"
            $cmakeGenerator = $vsVersionMap["2026"]
        }
        
        if ($vsVersion) {
            Write-Host "✓ تم اكتشاف Visual Studio $vsVersion من flutter doctor" -ForegroundColor Green
            Write-Host "✓ Detected Visual Studio $vsVersion from flutter doctor" -ForegroundColor Green
            $vsInstalled = $true
        }
    }
}

if (-not $vsInstalled) {
    Write-Host "✗ Visual Studio غير مثبت!" -ForegroundColor Red
    Write-Host ""
    Write-Host "يجب تثبيت Visual Studio 2022 أو أحدث مع مكونات C++ Desktop Development" -ForegroundColor Yellow
    Write-Host "You need to install Visual Studio 2022 or later with C++ Desktop Development components" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "التحميل من: https://visualstudio.microsoft.com/downloads/" -ForegroundColor Cyan
    Write-Host "Download from: https://visualstudio.microsoft.com/downloads/" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "المكونات المطلوبة:" -ForegroundColor Yellow
    Write-Host "Required components:" -ForegroundColor Yellow
    Write-Host "  - Desktop development with C++" -ForegroundColor White
    Write-Host "  - Windows 10/11 SDK" -ForegroundColor White
    Write-Host "  - CMake tools for Windows" -ForegroundColor White
    Write-Host ""
    exit 1
}

# إذا لم يتم تحديد المولد، استخدم 2022 كافتراضي
if (-not $cmakeGenerator) {
    Write-Host "⚠ لم يتم اكتشاف الإصدار، استخدام Visual Studio 17 2022 كافتراضي" -ForegroundColor Yellow
    Write-Host "⚠ Version not detected, using Visual Studio 17 2022 as default" -ForegroundColor Yellow
    $cmakeGenerator = "Visual Studio 17 2022"
}
Write-Host ""

# الخطوة 4: حذف مجلد build في windows
Write-Host "[4/5] حذف مجلد build في windows..." -ForegroundColor Yellow
Write-Host "[4/5] Removing windows build folder..." -ForegroundColor Yellow
if (Test-Path "windows\build") {
    Remove-Item -Path "windows\build" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "✓ تم حذف مجلد build" -ForegroundColor Green
} else {
    Write-Host "✓ لا يوجد مجلد build" -ForegroundColor Green
}
Write-Host ""

# الخطوة 5: التحقق من CMake
Write-Host "[5/5] التحقق من CMake..." -ForegroundColor Yellow
Write-Host "[5/5] Checking CMake..." -ForegroundColor Yellow
try {
    $cmakeVersion = cmake --version 2>&1 | Select-Object -First 1
    Write-Host "✓ $cmakeVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ CMake غير مثبت أو غير موجود في PATH" -ForegroundColor Red
    Write-Host "✗ CMake is not installed or not in PATH" -ForegroundColor Red
    exit 1
}
Write-Host ""

# محاولة البناء
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "محاولة بناء المشروع..." -ForegroundColor Cyan
Write-Host "Attempting to build project..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# تحديد مولد CMake بناءً على الإصدار المكتشف
# ملاحظة: Visual Studio 2026 يتطلب CMake 3.29+ أو استخدام Visual Studio 17 2022 generator
if ($vsVersion -eq "2026") {
    Write-Host "⚠ Visual Studio 2026 تم اكتشافه" -ForegroundColor Yellow
    Write-Host "⚠ Visual Studio 2026 detected" -ForegroundColor Yellow
    Write-Host ""
    
    # التحقق من إصدار CMake
    $cmakeVersionOutput = cmake --version 2>&1 | Select-Object -First 1
    if ($cmakeVersionOutput -match "version (\d+)\.(\d+)") {
        $cmakeMajor = [int]$matches[1]
        $cmakeMinor = [int]$matches[2]
        
        if ($cmakeMajor -gt 3 -or ($cmakeMajor -eq 3 -and $cmakeMinor -ge 29)) {
            Write-Host "✓ CMake $cmakeMajor.$cmakeMinor يدعم Visual Studio 2026" -ForegroundColor Green
            Write-Host "✓ CMake $cmakeMajor.$cmakeMinor supports Visual Studio 2026" -ForegroundColor Green
            $cmakeGenerator = "Visual Studio 18 2026"
        } else {
            Write-Host "✗ CMake $cmakeMajor.$cmakeMinor لا يدعم Visual Studio 2026" -ForegroundColor Red
            Write-Host "✗ CMake $cmakeMajor.$cmakeMinor does not support Visual Studio 2026" -ForegroundColor Red
            Write-Host ""
            Write-Host "يجب تحديث CMake إلى إصدار 3.29 أو أحدث لدعم Visual Studio 2026" -ForegroundColor Yellow
            Write-Host "You need to update CMake to version 3.29 or later to support Visual Studio 2026" -ForegroundColor Yellow
            Write-Host ""
            Write-Host "التحميل من: https://cmake.org/download/" -ForegroundColor Cyan
            Write-Host "Download from: https://cmake.org/download/" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "أو تثبيت Visual Studio 2022 بجانب Visual Studio 2026" -ForegroundColor Yellow
            Write-Host "Or install Visual Studio 2022 alongside Visual Studio 2026" -ForegroundColor Yellow
            Write-Host ""
            Write-Host "محاولة استخدام Visual Studio 17 2022 generator (قد لا يعمل)" -ForegroundColor Yellow
            Write-Host "Trying to use Visual Studio 17 2022 generator (may not work)" -ForegroundColor Yellow
            $cmakeGenerator = "Visual Studio 17 2022"
        }
    } else {
        Write-Host "⚠ لم يتم تحديد إصدار CMake، استخدام Visual Studio 17 2022 كافتراضي" -ForegroundColor Yellow
        Write-Host "⚠ Could not determine CMake version, using Visual Studio 17 2022 as default" -ForegroundColor Yellow
        $cmakeGenerator = "Visual Studio 17 2022"
    }
}

Write-Host "استخدام مولد CMake: $cmakeGenerator" -ForegroundColor Cyan
Write-Host "Using CMake generator: $cmakeGenerator" -ForegroundColor Cyan
Write-Host ""

# حذف ملفات CMake القديمة من build directory
Write-Host "حذف ملفات CMake القديمة من build directory..." -ForegroundColor Yellow
Write-Host "Removing old CMake files from build directory..." -ForegroundColor Yellow
$buildDir = "build\windows\x64"
if (Test-Path $buildDir) {
    Get-ChildItem -Path $buildDir -Include "CMakeCache.txt","CMakeFiles" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "✓ تم حذف ملفات CMake القديمة" -ForegroundColor Green
}
Write-Host ""

$env:CMAKE_GENERATOR = $cmakeGenerator
$env:CMAKE_GENERATOR_PLATFORM = "x64"

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
    Write-Host ""
    Write-Host "إذا استمرت المشكلة، تأكد من:" -ForegroundColor Yellow
    Write-Host "If the problem persists, make sure:" -ForegroundColor Yellow
    Write-Host "  1. Visual Studio 2022 مثبت مع مكونات C++" -ForegroundColor White
    Write-Host "  2. Windows SDK مثبت" -ForegroundColor White
    Write-Host "  3. قم بإعادة تشغيل الجهاز بعد تثبيت Visual Studio" -ForegroundColor White
    Write-Host ""
    Write-Host "Run 'flutter doctor -v' for more information" -ForegroundColor Cyan
}

