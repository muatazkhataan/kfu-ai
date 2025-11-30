import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// خدمة إدارة بيانات الدخول في نظام التشغيل
/// 
/// تدعم هذه الخدمة:
/// - Android: استخدام Autofill API مع FlutterSecureStorage
/// - iOS: Keychain
/// - حفظ واسترجاع بيانات الدخول تلقائياً
/// 
/// ملاحظة: يتم استخدام AutofillGroup و autofillHints في واجهة المستخدم
/// لجعل نظام التشغيل يعرض خيار حفظ بيانات الدخول تلقائياً
class CredentialManagerService {
  static CredentialManagerService? _instance;
  final FlutterSecureStorage _storage;

  /// مفاتيح التخزين
  static const String _studentNumberKey = 'saved_student_number';
  static const String _passwordKey = 'saved_password';
  static const String _userIdKey = 'saved_user_id';

  CredentialManagerService._internal()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
            // تفعيل دعم Autofill
            sharedPreferencesName: 'kfu_ai_autofill',
          ),
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock_this_device,
          ),
        );

  factory CredentialManagerService() {
    _instance ??= CredentialManagerService._internal();
    return _instance!;
  }

  /// حفظ بيانات الدخول في نظام التشغيل
  /// 
  /// [studentNumber] الرقم الجامعي
  /// [password] كلمة المرور
  /// [userId] معرف المستخدم (اختياري)
  Future<bool> saveCredentials({
    required String studentNumber,
    required String password,
    String? userId,
  }) async {
    try {
      await _storage.write(
        key: _studentNumberKey,
        value: studentNumber,
      );
      await _storage.write(
        key: _passwordKey,
        value: password,
      );
      if (userId != null) {
        await _storage.write(
          key: _userIdKey,
          value: userId,
        );
      }

      if (kDebugMode) {
        print('[CredentialManagerService] ✅ تم حفظ بيانات الدخول بنجاح');
        print('   - الرقم الجامعي: $studentNumber');
        print('   - User ID: ${userId ?? studentNumber}');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('[CredentialManagerService] ❌ خطأ في حفظ بيانات الدخول: $e');
      }
      return false;
    }
  }

  /// استرجاع بيانات الدخول المحفوظة
  /// 
  /// يُرجع Map يحتوي على:
  /// - 'studentNumber': الرقم الجامعي
  /// - 'password': كلمة المرور
  /// 
  /// يُرجع null إذا لم تكن هناك بيانات محفوظة
  Future<Map<String, String>?> getCredentials() async {
    try {
      final studentNumber = await _storage.read(key: _studentNumberKey);
      final password = await _storage.read(key: _passwordKey);

      if (studentNumber == null || password == null) {
        if (kDebugMode) {
          print('[CredentialManagerService] ℹ️ لا توجد بيانات دخول محفوظة');
        }
        return null;
      }

      final result = {
        'studentNumber': studentNumber,
        'password': password,
      };

      if (kDebugMode) {
        print('[CredentialManagerService] ✅ تم استرجاع بيانات الدخول');
        print('   - الرقم الجامعي: ${result['studentNumber']}');
      }

      return result;
    } catch (e) {
      if (kDebugMode) {
        print('[CredentialManagerService] ❌ خطأ في استرجاع بيانات الدخول: $e');
      }
      return null;
    }
  }

  /// حذف بيانات الدخول المحفوظة
  Future<bool> deleteCredentials() async {
    try {
      await _storage.delete(key: _studentNumberKey);
      await _storage.delete(key: _passwordKey);
      await _storage.delete(key: _userIdKey);

      if (kDebugMode) {
        print('[CredentialManagerService] ✅ تم حذف بيانات الدخول');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('[CredentialManagerService] ❌ خطأ في حذف بيانات الدخول: $e');
      }
      return false;
    }
  }

  /// التحقق من وجود بيانات دخول محفوظة
  Future<bool> hasSavedCredentials() async {
    try {
      final credentials = await getCredentials();
      return credentials != null;
    } catch (e) {
      if (kDebugMode) {
        print('[CredentialManagerService] ❌ خطأ في التحقق من وجود بيانات محفوظة: $e');
      }
      return false;
    }
  }
}

