import 'dart:convert';
import 'package:http/http.dart' as http;

/// اختبار API البحث مع الفلاتر المتقدمة
///
/// **تعليمات:**
/// 1. ضع رقمك الجامعي وكلمة مرورك أدناه
/// 2. شغّل: dart test_search_api_with_filters.dart
/// 3. راقب شكل الاستجابات مع الفلاتر المختلفة
/// 4. تأكد من عمل جميع أنواع الفلاتر

void main() async {
  // ⚠️ ضع بياناتك الحقيقية هنا ⚠️
  const studentNumber = '2284896111'; // الرقم الجامعي
  const password = 'Kfu@ai@2025'; // كلمة مرورك

  final baseUrl = 'https://kfusmartapi.kfu.edu.sa';

  print('🔍 اختبار API البحث مع الفلاتر المتقدمة...\n');
  print('⚠️ تأكد أن البيانات صحيحة!\n');

  // ==================== 1. Login ====================
  print('1️⃣ تسجيل الدخول...');
  String? accessToken;

  try {
    final loginResponse = await http.post(
      Uri.parse('$baseUrl/api/Users/login'),
      headers: {'Content-Type': 'application/json', 'Accept': '*/*'},
      body: jsonEncode({'StudentNumber': studentNumber, 'Password': password}),
    );

    if (loginResponse.statusCode == 200 && loginResponse.body.isNotEmpty) {
      final jsonResponse = jsonDecode(loginResponse.body);
      accessToken = jsonResponse['AccessToken'] ?? jsonResponse['accessToken'];

      if (accessToken != null) {
        print('✅ تم الحصول على Access Token!');
      }
    }
  } catch (e) {
    print('❌ خطأ في Login: $e');
    return;
  }

  if (accessToken == null) {
    print('⚠️ لم نحصل على Access Token - لا يمكن متابعة الاختبار');
    return;
  }

  print('\n${'=' * 60}\n');

  // ==================== 2. اختبار البحث البسيط ====================
  print('2️⃣ اختبار البحث البسيط...');

  try {
    final searchResponse = await http.post(
      Uri.parse('$baseUrl/api/Search/SearchChats'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'Query': 'اختبار',
        'Type': 'all',
        'SortBy': 'relevance',
        'Page': 1,
        'PageSize': 10,
      }),
    );

    print('📊 Status Code: ${searchResponse.statusCode}');
    print('📦 Response Body:');
    print(searchResponse.body);

    if (searchResponse.statusCode == 200 && searchResponse.body.isNotEmpty) {
      final jsonResponse = jsonDecode(searchResponse.body);
      print('\n📋 JSON Structure (formatted):');
      print(JsonEncoder.withIndent('  ').convert(jsonResponse));
    }
  } catch (e) {
    print('❌ خطأ في البحث البسيط: $e');
  }

  print('\n${'=' * 60}\n');

  // ==================== 3. اختبار البحث مع فلتر التاريخ ====================
  print('3️⃣ اختبار البحث مع فلتر التاريخ...');

  try {
    final searchWithDateResponse = await http.post(
      Uri.parse('$baseUrl/api/Search/SearchChats'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'Query': 'اختبار',
        'Type': 'all',
        'SortBy': 'date_desc',
        'StartDate': '2024-01-01T00:00:00Z',
        'EndDate': '2024-12-31T23:59:59Z',
        'Page': 1,
        'PageSize': 10,
      }),
    );

    print('📊 Status Code: ${searchWithDateResponse.statusCode}');
    print('📦 Response Body:');
    print(searchWithDateResponse.body);
  } catch (e) {
    print('❌ خطأ في البحث مع فلتر التاريخ: $e');
  }

  print('\n${'=' * 60}\n');

  // ==================== 4. اختبار البحث مع فلتر النوع ====================
  print('4️⃣ اختبار البحث مع فلتر النوع (المؤرشفة)...');

  try {
    final searchArchivedResponse = await http.post(
      Uri.parse('$baseUrl/api/Search/SearchChats'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'Query': 'اختبار',
        'Type': 'archived',
        'SortBy': 'date_desc',
        'Page': 1,
        'PageSize': 10,
      }),
    );

    print('📊 Status Code: ${searchArchivedResponse.statusCode}');
    print('📦 Response Body:');
    print(searchArchivedResponse.body);
  } catch (e) {
    print('❌ خطأ في البحث مع فلتر النوع: $e');
  }

  print('\n${'=' * 60}\n');

  // ==================== 5. اختبار البحث مع فلتر عدد الرسائل ====================
  print('5️⃣ اختبار البحث مع فلتر عدد الرسائل...');

  try {
    final searchWithMessageCountResponse = await http.post(
      Uri.parse('$baseUrl/api/Search/SearchChats'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'Query': 'اختبار',
        'Type': 'all',
        'SortBy': 'relevance',
        'MinMessageCount': 1,
        'MaxMessageCount': 50,
        'Page': 1,
        'PageSize': 10,
      }),
    );

    print('📊 Status Code: ${searchWithMessageCountResponse.statusCode}');
    print('📦 Response Body:');
    print(searchWithMessageCountResponse.body);
  } catch (e) {
    print('❌ خطأ في البحث مع فلتر عدد الرسائل: $e');
  }

  print('\n${'=' * 60}\n');

  // ==================== 6. اختبار البحث مع ترتيب مختلف ====================
  print('6️⃣ اختبار البحث مع ترتيب أبجدي...');

  try {
    final searchAlphabeticalResponse = await http.post(
      Uri.parse('$baseUrl/api/Search/SearchChats'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'Query': 'اختبار',
        'Type': 'all',
        'SortBy': 'title_asc',
        'Page': 1,
        'PageSize': 10,
      }),
    );

    print('📊 Status Code: ${searchAlphabeticalResponse.statusCode}');
    print('📦 Response Body:');
    print(searchAlphabeticalResponse.body);
  } catch (e) {
    print('❌ خطأ في البحث مع الترتيب الأبجدي: $e');
  }

  print('\n${'=' * 60}');
  print('\n✅ انتهى اختبار API البحث مع الفلاتر!');
  print('\n📝 النتائج:');
  print('   - تحقق من Status Codes (يجب أن تكون 200)');
  print('   - راجع Response Bodies للتأكد من البنية');
  print('   - تأكد من عمل جميع أنواع الفلاتر');
  print('   - اختبر التطبيق: flutter run');
}
