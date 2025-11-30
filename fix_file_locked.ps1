# Fix file locked issue for Flutter Windows build
# حل مشكلة الملف المقفل لبناء Flutter Windows

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Fixing File Locked Issue" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Close all Flutter/Dart processes
Write-Host "[1/3] Closing Flutter/Dart processes..." -ForegroundColor Yellow
$processes = Get-Process | Where-Object {
    $_.Path -like "*flutter*" -or 
    $_.Path -like "*dart*" -or 
    $_.ProcessName -like "*kfu_ai*" -or
    $_.ProcessName -like "*flutter_tester*" -or
    $_.ProcessName -like "*dartaotruntime*"
}

if ($processes) {
    $processes | ForEach-Object {
        try {
            Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
            Write-Host "Closed: $($_.ProcessName) (PID: $($_.Id))" -ForegroundColor Green
        } catch {
            Write-Host "Could not close: $($_.ProcessName)" -ForegroundColor Yellow
        }
    }
    Write-Host "Closed $($processes.Count) processes" -ForegroundColor Green
} else {
    Write-Host "No Flutter/Dart processes found" -ForegroundColor Green
}
Write-Host ""

# Step 2: Wait a moment for files to be released
Write-Host "[2/3] Waiting for files to be released..." -ForegroundColor Yellow
Start-Sleep -Seconds 2
Write-Host "Done" -ForegroundColor Green
Write-Host ""

# Step 3: Try to delete the locked file if it exists
Write-Host "[3/3] Checking locked file..." -ForegroundColor Yellow
$lockedFile = "C:\flutter\bin\cache\artifacts\engine\windows-x64\icudtl.dat"
if (Test-Path $lockedFile) {
    try {
        # Try to remove read-only attribute
        $file = Get-Item $lockedFile -ErrorAction SilentlyContinue
        if ($file) {
            $file.Attributes = $file.Attributes -band (-bnot [System.IO.FileAttributes]::ReadOnly)
        }
        Write-Host "File exists, will be replaced during build" -ForegroundColor Green
    } catch {
        Write-Host "Could not modify file attributes: $_" -ForegroundColor Yellow
    }
} else {
    Write-Host "File does not exist, will be downloaded" -ForegroundColor Green
}
Write-Host ""

# Build
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Building Windows app..." -ForegroundColor Cyan
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
    Write-Host "If the issue persists:" -ForegroundColor Yellow
    Write-Host "1. Close all Flutter/Dart applications" -ForegroundColor White
    Write-Host "2. Disable antivirus temporarily" -ForegroundColor White
    Write-Host "3. Run as Administrator" -ForegroundColor White
    Write-Host "4. Restart your computer" -ForegroundColor White
}

