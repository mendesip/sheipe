import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheipe_app/core/network/api_client.dart';
import 'package:sheipe_app/core/network/interceptors/auth_interceptor.dart';
import 'package:sheipe_app/features/auth/presentation/viewmodels/auth_view_model.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}
class MockAuthViewModel extends Mock implements AuthViewModel {}

void main() {
  test('ApiClient creates Dio with baseUrl and auth interceptor', () {
    final storage = MockSecureStorage();
    final authViewModel = MockAuthViewModel();
    final interceptor = AuthInterceptor(storage: storage, authViewModel: authViewModel);
    final client = ApiClient(baseUrl: 'http://localhost:3000', authInterceptor: interceptor);

    expect(client.dio.options.baseUrl, 'http://localhost:3000');
    expect(client.dio.interceptors.whereType<AuthInterceptor>().length, 1);
  });

  test('ApiClient sets correct headers and timeouts', () {
    final storage = MockSecureStorage();
    final authViewModel = MockAuthViewModel();
    final interceptor = AuthInterceptor(storage: storage, authViewModel: authViewModel);
    final client = ApiClient(baseUrl: 'http://api.test', authInterceptor: interceptor);

    expect(client.dio.options.headers['Accept'], 'application/json');
    expect(client.dio.options.headers['Content-Type'], 'application/json');
    expect(client.dio.options.connectTimeout, const Duration(seconds: 10));
    expect(client.dio.options.receiveTimeout, const Duration(seconds: 30));
  });
}
