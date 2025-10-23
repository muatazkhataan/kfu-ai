/// مثال على استخدام خدمة API في تطبيق مساعد كفو
///
/// هذا الملف يوضح كيفية استخدام جميع خدمات API بشكل عملي
library;

import 'package:kfu_ai/services/api/api_manager.dart';
import 'package:kfu_ai/services/api/auth/models/login_request.dart';
import 'package:kfu_ai/services/api/chat/models/send_message_request.dart';
import 'package:kfu_ai/services/api/chat/models/create_session_request.dart';
import 'package:kfu_ai/services/api/folder/models/create_folder_request.dart';
import 'package:kfu_ai/services/api/search/models/search_chats_request.dart';

/// مثال على تدفق Login → Chat → Logout
Future<void> fullWorkflowExample() async {
  final apiManager = ApiManager();

  print('🚀 بدء تدفق العمل الكامل...\n');

  // ==================== 1. تسجيل الدخول ====================
  print('📝 الخطوة 1: تسجيل الدخول...');
  final loginRequest = LoginRequest(
    studentNumber: '123456',
    password: 'password123',
  );

  final loginResponse = await apiManager.auth.login(loginRequest);

  if (loginResponse.success && loginResponse.data != null) {
    print('✅ تم تسجيل الدخول بنجاح!');
    print('   User ID: ${loginResponse.data!.userId}');
    print('   Token Type: ${loginResponse.data!.tokenType}\n');
  } else {
    print('❌ فشل تسجيل الدخول: ${loginResponse.error}\n');
    return;
  }

  // ==================== 2. إنشاء جلسة محادثة ====================
  print('💬 الخطوة 2: إنشاء جلسة محادثة...');
  final createSessionRequest = CreateSessionRequest(
    title: 'مساعدة في الخوارزميات',
  );

  final sessionResponse = await apiManager.chat.createSession(
    createSessionRequest,
  );

  String? sessionId;
  if (sessionResponse.success && sessionResponse.data != null) {
    sessionId = sessionResponse.data!.sessionId;
    print('✅ تم إنشاء الجلسة بنجاح!');
    print('   Session ID: $sessionId');
    print('   Title: ${sessionResponse.data!.title}\n');
  } else {
    print('❌ فشل إنشاء الجلسة: ${sessionResponse.error}\n');
    return;
  }

  // ==================== 3. إرسال رسالة ====================
  print('✉️ الخطوة 3: إرسال رسالة...');
  final sendMessageRequest = SendMessageRequest(
    sessionId: sessionId,
    content: 'ما هي خوارزمية البحث الثنائي؟',
  );

  final messageResponse = await apiManager.chat.sendMessage(sendMessageRequest);

  if (messageResponse.success && messageResponse.data != null) {
    print('✅ تم إرسال الرسالة واستقبال الرد!');
    print('   الرسالة: ${sendMessageRequest.content}');
    print('   الرد: ${messageResponse.data!.content}\n');
  } else {
    print('❌ فشل إرسال الرسالة: ${messageResponse.error}\n');
  }

  // ==================== 4. إنشاء مجلد ====================
  print('📁 الخطوة 4: إنشاء مجلد...');
  final createFolderRequest = CreateFolderRequest(
    name: 'الخوارزميات',
    icon: 'chart-network',
  );

  final folderResponse = await apiManager.folder.createFolder(
    createFolderRequest,
  );

  if (folderResponse.success && folderResponse.data != null) {
    print('✅ تم إنشاء المجلد بنجاح!');
    print('   Folder ID: ${folderResponse.data!.folderId}');
    print('   Name: ${folderResponse.data!.name}\n');
  } else {
    print('❌ فشل إنشاء المجلد: ${folderResponse.error}\n');
  }

  // ==================== 5. البحث في المحادثات ====================
  print('🔍 الخطوة 5: البحث في المحادثات...');
  final searchRequest = SearchChatsRequest(query: 'خوارزميات');

  final searchResponse = await apiManager.search.searchChats(searchRequest);

  if (searchResponse.success && searchResponse.data != null) {
    print('✅ تم البحث بنجاح!');
    print('   عدد النتائج: ${searchResponse.data!.length}');
    for (var session in searchResponse.data!) {
      print('   - ${session.title}');
    }
    print('');
  } else {
    print('❌ فشل البحث: ${searchResponse.error}\n');
  }

  // ==================== 6. الحصول على جميع الجلسات ====================
  print('📋 الخطوة 6: الحصول على جميع الجلسات...');
  final sessionsResponse = await apiManager.chat.getUserSessions();

  if (sessionsResponse.success && sessionsResponse.data != null) {
    print('✅ تم الحصول على الجلسات بنجاح!');
    print('   عدد الجلسات: ${sessionsResponse.data!.length}');
    for (var session in sessionsResponse.data!) {
      print('   - ${session.title} (${session.messageCount ?? 0} رسالة)');
    }
    print('');
  } else {
    print('❌ فشل الحصول على الجلسات: ${sessionsResponse.error}\n');
  }

  // ==================== 7. تسجيل الخروج ====================
  print('👋 الخطوة 7: تسجيل الخروج...');
  final logoutResponse = await apiManager.logout();

  if (logoutResponse.success) {
    print('✅ تم تسجيل الخروج بنجاح!\n');
  } else {
    print('❌ فشل تسجيل الخروج: ${logoutResponse.error}\n');
  }

  print('🎉 انتهى تدفق العمل الكامل!');
}

/// مثال على معالجة الأخطاء
Future<void> errorHandlingExample() async {
  final apiManager = ApiManager();

  print('\n🛠️ مثال على معالجة الأخطاء...\n');

  // محاولة تسجيل دخول ببيانات خاطئة
  final loginRequest = LoginRequest(
    studentNumber: 'wrong_id',
    password: 'wrong_password',
  );

  final response = await apiManager.auth.login(loginRequest);

  if (response.success) {
    print('✅ نجح تسجيل الدخول');
  } else {
    print('❌ فشل تسجيل الدخول:');
    print('   الخطأ: ${response.error}');
    print('   كود الخطأ: ${response.errorCode}');
    print('   كود الحالة: ${response.statusCode}');
  }
}

/// مثال على التحقق من الجلسة
Future<void> sessionValidationExample() async {
  final apiManager = ApiManager();

  print('\n🔐 مثال على التحقق من الجلسة...\n');

  // التحقق من تسجيل الدخول
  if (apiManager.isAuthenticated) {
    print('✅ المستخدم مسجل الدخول');

    // التحقق من صلاحية الجلسة
    final isValid = await apiManager.isSessionValid();
    if (isValid) {
      print('✅ الجلسة صالحة ونشطة');

      // الحصول على معرف المستخدم
      final userId = await apiManager.getCurrentUserId();
      print('📋 معرف المستخدم: $userId');
    } else {
      print('⚠️ الجلسة منتهية - يجب تسجيل الدخول مرة أخرى');
    }
  } else {
    print('❌ المستخدم غير مسجل الدخول');
  }
}

/// مثال على إدارة المجلدات
Future<void> folderManagementExample() async {
  final apiManager = ApiManager();

  print('\n📁 مثال على إدارة المجلدات...\n');

  // 1. الحصول على جميع المجلدات
  print('1️⃣ الحصول على جميع المجلدات...');
  final foldersResponse = await apiManager.folder.getAllFolders();

  if (foldersResponse.success && foldersResponse.data != null) {
    print('   عدد المجلدات: ${foldersResponse.data!.length}');
    for (var folder in foldersResponse.data!) {
      print('   📂 ${folder.name} (${folder.chatCount} محادثة)');
    }
  }

  // 2. إنشاء مجلد جديد
  print('\n2️⃣ إنشاء مجلد جديد...');
  final createRequest = CreateFolderRequest(
    name: 'هياكل البيانات',
    icon: 'database',
  );
  final createResponse = await apiManager.folder.createFolder(createRequest);

  if (createResponse.success && createResponse.data != null) {
    print('   ✅ تم إنشاء المجلد: ${createResponse.data!.name}');
  }
}

/// مثال على إدارة المحادثات
Future<void> chatManagementExample() async {
  final apiManager = ApiManager();

  print('\n💬 مثال على إدارة المحادثات...\n');

  // 1. إنشاء جلسة جديدة
  print('1️⃣ إنشاء جلسة جديدة...');
  final createRequest = CreateSessionRequest(title: 'مساعدة في البرمجة');
  final createResponse = await apiManager.chat.createSession(createRequest);

  String? sessionId;
  if (createResponse.success && createResponse.data != null) {
    sessionId = createResponse.data!.sessionId;
    print('   ✅ تم إنشاء الجلسة: $sessionId');

    // 2. إرسال رسالة
    print('\n2️⃣ إرسال رسالة...');
    final messageRequest = SendMessageRequest(
      sessionId: sessionId,
      content: 'اشرح لي مفهوم الوراثة في OOP',
    );
    final messageResponse = await apiManager.chat.sendMessage(messageRequest);

    if (messageResponse.success) {
      print('   ✅ تم إرسال الرسالة واستقبال الرد');
    }

    // 3. تحديث عنوان الجلسة
    print('\n3️⃣ تحديث عنوان الجلسة...');
    // (مثال - يحتاج لاستيراد UpdateSessionTitleRequest)

    // 4. أرشفة الجلسة
    print('\n4️⃣ أرشفة الجلسة...');
    final archiveResponse = await apiManager.chat.archiveSession(sessionId);

    if (archiveResponse.success) {
      print('   ✅ تم أرشفة الجلسة');
    }
  }
}

/// نقطة الدخول الرئيسية
void main() async {
  print('═══════════════════════════════════════════════');
  print('   📱 أمثلة استخدام API - تطبيق مساعد كفو');
  print('═══════════════════════════════════════════════\n');

  // تشغيل الأمثلة
  await fullWorkflowExample();
  await errorHandlingExample();
  await sessionValidationExample();
  await folderManagementExample();
  await chatManagementExample();

  print('\n═══════════════════════════════════════════════');
  print('   ✨ انتهت جميع الأمثلة بنجاح!');
  print('═══════════════════════════════════════════════');
}
