import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// مدير الـ Tokens
///
/// يدير حفظ واسترجاع الـ Tokens بشكل آمن
class TokenManager {
  /// مثيل Flutter Secure Storage
  final FlutterSecureStorage _storage;

  /// مفاتيح التخزين
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _tokenExpiryKey = 'token_expiry';
  static const String _rememberMeKey = 'remember_me';

  /// Constructor
  TokenManager({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock,
            ),
          );

  /// حفظ Tokens
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String userId,
    int? expiresIn,
    bool rememberMe = false,
  }) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
      _storage.write(key: _userIdKey, value: userId),
      _storage.write(key: _rememberMeKey, value: rememberMe.toString()),
      if (expiresIn != null)
        _storage.write(
          key: _tokenExpiryKey,
          value: DateTime.now()
              .add(Duration(seconds: expiresIn))
              .toIso8601String(),
        ),
    ]);
  }

  /// الحصول على Access Token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// الحصول على Refresh Token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// الحصول على معرف المستخدم
  Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  /// الحصول على تاريخ انتهاء Token
  Future<DateTime?> getTokenExpiry() async {
    final expiryStr = await _storage.read(key: _tokenExpiryKey);
    if (expiryStr == null) return null;
    return DateTime.tryParse(expiryStr);
  }

  /// الحصول على تفضيل "تذكرني"
  Future<bool> getRememberMe() async {
    final rememberMeStr = await _storage.read(key: _rememberMeKey);
    if (rememberMeStr == null) return false;
    return rememberMeStr.toLowerCase() == 'true';
  }

  /// التحقق من صلاحية Token
  Future<bool> isTokenValid() async {
    final token = await getAccessToken();
    if (token == null || token.isEmpty) return false;

    final expiry = await getTokenExpiry();
    if (expiry == null) {
      return true; // افترض أنه صالح إذا لم يكن هناك تاريخ انتهاء
    }

    return DateTime.now().isBefore(expiry);
  }

  /// التحقق من انتهاء صلاحية Token
  Future<bool> isTokenExpired() async {
    return !(await isTokenValid());
  }

  /// حذف جميع Tokens
  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
      _storage.delete(key: _userIdKey),
      _storage.delete(key: _tokenExpiryKey),
      _storage.delete(key: _rememberMeKey),
    ]);
  }

  /// التحقق من وجود Tokens
  Future<bool> hasTokens() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    return accessToken != null &&
        accessToken.isNotEmpty &&
        refreshToken != null &&
        refreshToken.isNotEmpty;
  }

  /// تحديث Access Token فقط
  Future<void> updateAccessToken(String accessToken, {int? expiresIn}) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    if (expiresIn != null) {
      await _storage.write(
        key: _tokenExpiryKey,
        value: DateTime.now()
            .add(Duration(seconds: expiresIn))
            .toIso8601String(),
      );
    }
  }

  /// الحصول على جميع معلومات Token
  Future<TokenInfo?> getTokenInfo() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    final userId = await getUserId();
    final expiry = await getTokenExpiry();
    final rememberMe = await getRememberMe();

    if (accessToken == null || refreshToken == null || userId == null) {
      return null;
    }

    return TokenInfo(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userId: userId,
      expiry: expiry,
      rememberMe: rememberMe,
    );
  }
}

/// معلومات Token
class TokenInfo {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final DateTime? expiry;
  final bool rememberMe;

  const TokenInfo({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    this.expiry,
    this.rememberMe = false,
  });

  bool get isExpired => expiry != null && DateTime.now().isAfter(expiry!);

  bool get isValid => !isExpired;

  @override
  String toString() {
    return 'TokenInfo(userId: $userId, isExpired: $isExpired, rememberMe: $rememberMe)';
  }
}
