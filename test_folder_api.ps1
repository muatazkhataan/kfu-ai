# سكريبت PowerShell لاختبار API المجلدات

$accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiIyOTYxMTAwOS1mNjA1LTQ4MTAtODExMC0yMzI5YWUwNTJlNGUiLCJuYmYiOjE3NjQ0OTE4OTYsImV4cCI6MTc2NTc4Nzg5NiwiaWF0IjoxNzY0NDkxODk2LCJpc3MiOiJzZWN1cmVhcGkiLCJhdWQiOiJzZWN1cmVhcGlpdXNlcnMifQ.1_KDbAWVeM0H0dps5VX0hmviDvI0-X2N2EGRVZErH04"
$url = "https://kfusmartapi.kfu.edu.sa/api/Folder/GetAllFolder"

Write-Host "🔍 اختبار API المجلدات..." -ForegroundColor Cyan
Write-Host ""
Write-Host "URL: $url" -ForegroundColor Yellow
Write-Host "Token: $($accessToken.Substring(0, 50))..." -ForegroundColor Yellow
Write-Host ""

try {
    $headers = @{
        "Authorization" = "Bearer $accessToken"
        "Content-Type" = "application/json"
        "Accept" = "application/json"
    }

    Write-Host "📤 إرسال الطلب..." -ForegroundColor Green
    Write-Host ""
    Write-Host "Headers:" -ForegroundColor Cyan
    foreach ($key in $headers.Keys) {
        if ($key -eq "Authorization") {
            Write-Host "  $key : Bearer $($accessToken.Substring(0, 50))..." -ForegroundColor Gray
        } else {
            Write-Host "  $key : $($headers[$key])" -ForegroundColor Gray
        }
    }
    Write-Host ""

    $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop

    Write-Host "📥 الاستجابة:" -ForegroundColor Green
    Write-Host "Status: Success" -ForegroundColor Green
    Write-Host ""

    Write-Host "📄 محتوى الاستجابة:" -ForegroundColor Cyan
    Write-Host "=" * 80 -ForegroundColor Gray
    
    # تحويل إلى JSON منسق
    $formattedJson = $response | ConvertTo-Json -Depth 10
    Write-Host $formattedJson -ForegroundColor White
    Write-Host "=" * 80 -ForegroundColor Gray
    Write-Host ""

    # تحليل البيانات
    if ($response -is [Array]) {
        Write-Host "📊 تحليل البيانات:" -ForegroundColor Cyan
        Write-Host "عدد المجلدات: $($response.Count)" -ForegroundColor Yellow
        Write-Host ""

        if ($response.Count -gt 0) {
            Write-Host "مثال على مجلد واحد:" -ForegroundColor Cyan
            $firstFolder = $response[0]
            
            # محاولة استخراج البيانات بطرق مختلفة
            $id = $firstFolder.Id -or $firstFolder.id -or $firstFolder.FolderId -or $firstFolder.folderId
            $name = $firstFolder.Name -or $firstFolder.name
            $icon = $firstFolder.Icon -or $firstFolder.icon
            $color = $firstFolder.Color -or $firstFolder.color
            $order = $firstFolder.Order -or $firstFolder.order
            $metadata = $firstFolder.Metadata -or $firstFolder.metadata
            
            Write-Host "  - ID: $id" -ForegroundColor White
            Write-Host "  - Name: $name" -ForegroundColor White
            Write-Host "  - Icon: $icon" -ForegroundColor White
            Write-Host "  - Color (مستوى رئيسي): $color" -ForegroundColor White
            Write-Host "  - Order: $order" -ForegroundColor White
            
            if ($metadata) {
                Write-Host "  - Metadata:" -ForegroundColor White
                $metadataColor = $metadata.color -or $metadata.Color
                $metadataIcon = $metadata.iconClass -or $metadata.IconClass
                $metadataIsFixed = $metadata.isFixed -or $metadata.IsFixed
                
                Write-Host "    - iconClass: $metadataIcon" -ForegroundColor Gray
                Write-Host "    - color: $metadataColor" -ForegroundColor Gray
                Write-Host "    - isFixed: $metadataIsFixed" -ForegroundColor Gray
            }
            
            Write-Host ""
            Write-Host "🔍 تحليل بنية البيانات:" -ForegroundColor Cyan
            Write-Host "المفاتيح المتاحة في المجلد الأول:" -ForegroundColor Yellow
            $firstFolder.PSObject.Properties.Name | ForEach-Object {
                Write-Host "  - $_" -ForegroundColor Gray
            }
        }
    } elseif ($response -is [PSCustomObject]) {
        Write-Host "📊 تحليل البيانات:" -ForegroundColor Cyan
        Write-Host "نوع البيانات: Object" -ForegroundColor Yellow
        Write-Host "المفاتيح: $($response.PSObject.Properties.Name -join ', ')" -ForegroundColor Yellow
    }

} catch {
    Write-Host "❌ خطأ: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    
    if ($_.Exception.Response) {
        $statusCode = $_.Exception.Response.StatusCode.value__
        Write-Host "Status Code: $statusCode" -ForegroundColor Red
        
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host "Response Body: $responseBody" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "Stack Trace:" -ForegroundColor Red
    Write-Host $_.ScriptStackTrace -ForegroundColor Gray
}

