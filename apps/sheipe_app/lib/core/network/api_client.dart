import 'package:dio/dio.dart';
import 'interceptors/auth_interceptor.dart';

class ApiClient {
  ApiClient({
    required String baseUrl,
    required AuthInterceptor authInterceptor,
  }) : _dio = _buildDio(baseUrl, authInterceptor);

  final Dio _dio;

  Dio get dio => _dio;

  static Dio _buildDio(String baseUrl, AuthInterceptor authInterceptor) {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
    ));
    dio.interceptors.add(authInterceptor);
    return dio;
  }
}
