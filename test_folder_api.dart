import 'dart:convert';
import 'dart:io';

/// سكريبت لاختبار API المجلدات
/// 
/// يستخدم AccessToken المقدم لاختبار endpoint GetAllFolder
Future<void> main() async {
  const accessToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiIyOTYxMTAwOS1mNjA1LTQ4MTAtODExMC0yMzI5YWUwNTJlNGUiLCJuYmYiOjE3NjQ0OTE4OTYsImV4cCI6MTc2NTc4Nzg5NiwiaWF0IjoxNzY0NDkxODk2LCJpc3MiOiJzZWN1cmVhcGkiLCJhdWQiOiJzZWN1cmVhcGlpdXNlcnMifQ.1_KDbAWVeM0H0dps5VX0hmviDvI0-X2N2EGRVZErH04';
  const url = 'https://kfusmartapi.kfu.edu.sa/api/Folder/GetAllFolder';

  print('🔍 اختبار API المجلدات...\n');
  print('URL: $url');
  print('Token: ${accessToken.substring(0, 50)}...\n');

  try {
    final client = HttpClient();
    final request = await client.getUrl(Uri.parse(url));
    
    // إضافة Headers
    request.headers.set('Authorization', 'Bearer $accessToken');
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('Accept', 'application/json');

    print('📤 إرسال الطلب...\n');
    print('Headers:');
    request.headers.forEach((key, values) {
      print('  $key: ${values.join(", ")}');
    });
    print('');

    final response = await request.close();
    final statusCode = response.statusCode;
    
    print('📥 الاستجابة:');
    print('Status Code: $statusCode');
    print('Status Message: ${response.reasonPhrase}');
    print('');

    // قراءة المحتوى
    final responseBody = await response.transform(utf8.decoder).join();
    
    print('📄 محتوى الاستجابة:');
    print('=' * 80);
    
    if (responseBody.isNotEmpty) {
      try {
        // محاولة تنسيق JSON
        final jsonData = jsonDecode(responseBody);
        final formattedJson = const JsonEncoder.withIndent('  ').convert(jsonData);
        print(formattedJson);
        
        // تحليل البيانات
        if (jsonData is List) {
          print('\n📊 تحليل البيانات:');
          print('عدد المجلدات: ${jsonData.length}');
          if (jsonData.isNotEmpty) {
            print('\nمثال على مجلد واحد:');
            final firstFolder = jsonData[0];
            print('  - ID: ${firstFolder['Id'] ?? firstFolder['id'] ?? 'N/A'}');
            print('  - Name: ${firstFolder['Name'] ?? firstFolder['name'] ?? 'N/A'}');
            print('  - Icon: ${firstFolder['Icon'] ?? firstFolder['icon'] ?? 'N/A'}');
            print('  - Color: ${firstFolder['Color'] ?? firstFolder['color'] ?? firstFolder['Metadata']?['Color'] ?? 'N/A'}');
            print('  - Order: ${firstFolder['Order'] ?? firstFolder['order'] ?? 'N/A'}');
            print('  - Metadata: ${firstFolder['Metadata'] ?? 'N/A'}');
          }
        } else if (jsonData is Map) {
          print('\n📊 تحليل البيانات:');
          print('نوع البيانات: Map');
          print('المفاتيح: ${jsonData.keys.join(", ")}');
        }
      } catch (e) {
        print('⚠️  لا يمكن تنسيق JSON: $e');
        print('المحتوى الخام:');
        print(responseBody);
      }
    } else {
      print('(فارغ)');
    }
    
    print('=' * 80);

    client.close();
  } catch (e, stackTrace) {
    print('❌ خطأ: $e');
    print('\nStack Trace:');
    print(stackTrace);
  }
}

