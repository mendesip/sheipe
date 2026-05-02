import 'dart:async';
import 'package:dio/dio.dart';
import '../auth_event.dart';
import '../../../features/auth/data/local/auth_local_data_source.dart';

class AuthInterceptor extends QueuedInterceptorsWrapper {
  AuthInterceptor({
    required AuthLocalDataSource localDataSource,
    required StreamSink<AuthEvent> authEventSink,
    required String baseUrl,
  })  : _local = localDataSource,
        _authEventSink = authEventSink,
        _baseUrl = baseUrl;

  final AuthLocalDataSource _local;
  final StreamSink<AuthEvent> _authEventSink;
  final String _baseUrl;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _local.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    final refreshToken = await _local.getRefreshToken();
    if (refreshToken == null) {
      await _local.clearTokens();
      _authEventSink.add(const AuthUnauthorized());
      handler.next(err);
      return;
    }

    try {
      final refreshDio = Dio(BaseOptions(
        baseUrl: _baseUrl,
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
      ));

      final response = await refreshDio.post<Map<String, dynamic>>(
        '/api/v1/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final newAccessToken = response.data!['access_token'] as String;
      await _local.saveTokens(
        accessToken: newAccessToken,
        refreshToken: refreshToken,
      );

      final retryOptions = err.requestOptions;
      retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';
      final retryResponse = await refreshDio.fetch<dynamic>(retryOptions);
      handler.resolve(retryResponse);
    } catch (_) {
      await _local.clearTokens();
      _authEventSink.add(const AuthUnauthorized());
      handler.next(err);
    }
  }
}
