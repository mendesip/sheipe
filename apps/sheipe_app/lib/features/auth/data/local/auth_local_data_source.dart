import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/entities/user.dart';

class AuthLocalDataSource {
  const AuthLocalDataSource({required FlutterSecureStorage storage}) : _storage = storage;

  final FlutterSecureStorage _storage;

  static const _accessTokenKey = 'auth_access_token';
  static const _refreshTokenKey = 'auth_refresh_token';
  static const _userJsonKey = 'auth_user_json';
  static const _onboardingKey = 'onboarding_seen';

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
    ]);
  }

  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
    ]);
  }

  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);

  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<void> saveUser(User user) =>
      _storage.write(key: _userJsonKey, value: json.encode(user.toJson()));

  Future<User?> getUser() async {
    final raw = await _storage.read(key: _userJsonKey);
    if (raw == null) return null;
    return User.fromJson(json.decode(raw) as Map<String, dynamic>);
  }

  Future<void> clearUser() => _storage.delete(key: _userJsonKey);

  Future<void> markOnboardingSeen() =>
      _storage.write(key: _onboardingKey, value: 'true');

  Future<bool> isOnboardingSeen() async {
    final val = await _storage.read(key: _onboardingKey);
    return val == 'true';
  }
}
