import 'package:dio/dio.dart';
import '../../domain/entities/user.dart';

typedef AuthTokens = ({String accessToken, String refreshToken});
typedef AuthResult = ({AuthTokens tokens, User user});

class AuthRemoteDataSource {
  const AuthRemoteDataSource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String role,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v1/auth/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'role': role,
      },
    );
    return _parseAuthResult(response.data!);
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v1/auth/login',
      data: {'email': email, 'password': password},
    );
    return _parseAuthResult(response.data!);
  }

  Future<String> refresh({required String refreshToken}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v1/auth/refresh',
      data: {'refresh_token': refreshToken},
    );
    return response.data!['access_token'] as String;
  }

  Future<void> logout() => _dio.delete<void>('/api/v1/auth/logout');

  Future<User> getMe() async {
    final response = await _dio.get<Map<String, dynamic>>('/api/v1/me');
    return User.fromJson(response.data!);
  }

  Future<User> updateMe({required String name}) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/api/v1/me',
      data: {'name': name},
    );
    return User.fromJson(response.data!);
  }

  AuthResult _parseAuthResult(Map<String, dynamic> data) {
    final tokens = (
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String,
    );
    final user = User.fromJson(data['user'] as Map<String, dynamic>);
    return (tokens: tokens, user: user);
  }
}
