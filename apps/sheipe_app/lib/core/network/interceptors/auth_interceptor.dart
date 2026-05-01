import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../features/auth/presentation/viewmodels/auth_view_model.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required FlutterSecureStorage storage,
    required AuthViewModel authViewModel,
  })  : _storage = storage,
        _authViewModel = authViewModel;

  final FlutterSecureStorage _storage;
  final AuthViewModel _authViewModel;
  static const _tokenKey = 'auth_token';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(key: _tokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    if (response.statusCode == 401) {
      await _storage.delete(key: _tokenKey);
      await _authViewModel.logout();
    }
    handler.next(response);
  }
}
