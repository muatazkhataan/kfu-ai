import 'dart:convert';
import 'package:http/http.dart' as http;

/// اختبار API مع بيانات حقيقية
///
/// **تعليمات:**
/// 1. ضع رقمك الجامعي وكلمة مرورك أدناه
/// 2. شغّل: dart test_api_with_real_data.dart
/// 3. راقب شكل الاستجابات
/// 4. حدّث DTOs بناءً على النتائج

void main() async {
  // ⚠️ ضع بياناتك الحقيقية هنا ⚠️
  const studentNumber = '2284896111'; // الرقم الجامعي
  const password = 'Kfu@ai@2025'; // كلمة مرورك

  final baseUrl = 'https://kfuai-api.kfu.edu.sa';

  print('🔍 اختبار API مع بيانات حقيقية...\n');
  print('⚠️ تأكد أن البيانات صحيحة!\n');

  // ==================== 1. Login ====================
  print('1️⃣ اختبار Login...');
  String? accessToken;
  String? userId;

  try {
    final loginResponse = await http.post(
      Uri.parse('$baseUrl/api/Users/login'),
      headers: {'Content-Type': 'application/json', 'Accept': '*/*'},
      body: jsonEncode({'StudentNumber': studentNumber, 'Password': password}),
    );

    print('📊 Status Code: ${loginResponse.statusCode}');
    print('📦 Response Body:');
    print(loginResponse.body);

    if (loginResponse.statusCode == 200 && loginResponse.body.isNotEmpty) {
      final jsonResponse = jsonDecode(loginResponse.body);
      print('\n📋 JSON Structure (formatted):');
      print(JsonEncoder.withIndent('  ').convert(jsonResponse));

      // محاولة استخراج Token
      if (jsonResponse is Map<String, dynamic>) {
        accessToken =
            jsonResponse['AccessToken'] ??
            jsonResponse['accessToken'] ??
            jsonResponse['token'] ??
            jsonResponse['Data']?['AccessToken'] ??
            jsonResponse['Data']?['accessToken'];

        userId =
            jsonResponse['UserId'] ??
            jsonResponse['userId'] ??
            jsonResponse['Data']?['UserId'] ??
            jsonResponse['Data']?['userId'];

        if (accessToken != null) {
          print('\n✅ تم الحصول على Access Token!');
          print('Token (أول 20 حرف): ${accessToken.substring(0, 20)}...');
        }

        if (userId != null) {
          print('User ID: $userId');
        }
      }
    }
  } catch (e) {
    print('❌ خطأ في Login: $e');
  }

  print('\n' + '=' * 60 + '\n');

  // إذا لم نحصل على token، توقف
  if (accessToken == null) {
    print('⚠️ لم نحصل على Access Token - لا يمكن متابعة الاختبار');
    print('تحقق من صحة البيانات وأعد المحاولة');
    return;
  }

  // ==================== 2. GetUserSessions ====================
  print('2️⃣ اختبار GetUserSessions...');

  try {
    final sessionsResponse = await http.get(
      Uri.parse('$baseUrl/api/Chat/GetUserSessions'),
      headers: {'Accept': '*/*', 'Authorization': 'Bearer $accessToken'},
    );

    print('📊 Status Code: ${sessionsResponse.statusCode}');
    print('📦 Response Body:');
    print(sessionsResponse.body);

    if (sessionsResponse.statusCode == 200 &&
        sessionsResponse.body.isNotEmpty) {
      final jsonResponse = jsonDecode(sessionsResponse.body);
      print('\n📋 JSON Structure (formatted):');
      print(JsonEncoder.withIndent('  ').convert(jsonResponse));

      // تحليل البنية
      print('\n🔍 تحليل البنية:');
      if (jsonResponse is List) {
        print('   Type: Array مباشر');
        print('   Count: ${jsonResponse.length}');
        if (jsonResponse.isNotEmpty) {
          print(
            '   First Item Keys: ${(jsonResponse[0] as Map).keys.join(', ')}',
          );
        }
      } else if (jsonResponse is Map) {
        print('   Type: Object مع wrapper');
        print('   Keys: ${jsonResponse.keys.join(', ')}');
      }
    }
  } catch (e) {
    print('❌ خطأ في GetUserSessions: $e');
  }

  print('\n' + '=' * 60 + '\n');

  // ==================== 3. GetRecentChats ====================
  print('3️⃣ اختبار GetRecentChats...');

  try {
    final recentResponse = await http.get(
      Uri.parse('$baseUrl/api/Search/GetRecentChats'),
      headers: {'Accept': '*/*', 'Authorization': 'Bearer $accessToken'},
    );

    print('📊 Status Code: ${recentResponse.statusCode}');
    print('📦 Response Body:');
    print(recentResponse.body);

    if (recentResponse.statusCode == 200 && recentResponse.body.isNotEmpty) {
      final jsonResponse = jsonDecode(recentResponse.body);
      print('\n📋 JSON Structure (formatted):');
      print(JsonEncoder.withIndent('  ').convert(jsonResponse));
    }
  } catch (e) {
    print('❌ خطأ في GetRecentChats: $e');
  }

  print('\n' + '=' * 60 + '\n');

  // ==================== 4. GetAllFolder ====================
  print('4️⃣ اختبار GetAllFolder...');

  try {
    final foldersResponse = await http.get(
      Uri.parse('$baseUrl/api/Folder/GetAllFolder'),
      headers: {'Accept': '*/*', 'Authorization': 'Bearer $accessToken'},
    );

    print('📊 Status Code: ${foldersResponse.statusCode}');
    print('📦 Response Body:');
    print(foldersResponse.body);

    if (foldersResponse.statusCode == 200 && foldersResponse.body.isNotEmpty) {
      final jsonResponse = jsonDecode(foldersResponse.body);
      print('\n📋 JSON Structure (formatted):');
      print(JsonEncoder.withIndent('  ').convert(jsonResponse));
    }
  } catch (e) {
    print('❌ خطأ في GetAllFolder: $e');
  }

  print('\n' + '=' * 60 + '\n');

  // ==================== 5. CreateSession ====================
  print('5️⃣ اختبار CreateSession...');

  try {
    final createResponse = await http.post(
      Uri.parse('$baseUrl/api/Chat/CreateSession'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({'title': 'اختبار جلسة من التطبيق'}),
    );

    print('📊 Status Code: ${createResponse.statusCode}');
    print('📦 Response Body:');
    print(createResponse.body);

    if (createResponse.statusCode == 200 && createResponse.body.isNotEmpty) {
      final jsonResponse = jsonDecode(createResponse.body);
      print('\n📋 JSON Structure (formatted):');
      print(JsonEncoder.withIndent('  ').convert(jsonResponse));
    }
  } catch (e) {
    print('❌ خطأ في CreateSession: $e');
  }

  print('\n' + '=' * 60);
  print('\n✅ انتهى الاختبار!');
  print('\n📝 الخطوة التالية:');
  print('   1. راجع الاستجابات أعلاه');
  print('   2. قارن مع DTOs الحالية');
  print('   3. حدّث DTOs إذا لزم الأمر');
  print('   4. اختبر التطبيق: flutter run');
}
