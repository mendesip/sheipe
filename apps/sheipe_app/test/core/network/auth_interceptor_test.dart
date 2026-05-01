import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheipe_app/core/network/interceptors/auth_interceptor.dart';
import 'package:sheipe_app/features/auth/presentation/viewmodels/auth_view_model.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}
class MockAuthViewModel extends Mock implements AuthViewModel {}
class MockHandler extends Mock implements RequestInterceptorHandler {}
class MockResponseHandler extends Mock implements ResponseInterceptorHandler {}

class FakeRequestOptions extends Fake implements RequestOptions {}
class FakeResponse extends Fake implements Response<dynamic> {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeRequestOptions());
    registerFallbackValue(FakeResponse());
  });

  late MockSecureStorage storage;
  late MockAuthViewModel authViewModel;

  setUp(() {
    storage = MockSecureStorage();
    authViewModel = MockAuthViewModel();
  });

  group('AuthInterceptor — request', () {
    test('attaches Bearer token header when token is present', () async {
      when(() => storage.read(key: 'auth_token')).thenAnswer((_) async => 'my_token');
      final interceptor = AuthInterceptor(storage: storage, authViewModel: authViewModel);
      final options = RequestOptions(path: '/test');
      final handler = MockHandler();
      when(() => handler.next(any())).thenReturn(null);

      await interceptor.onRequest(options, handler);

      final captured = verify(() => handler.next(captureAny())).captured.first as RequestOptions;
      expect(captured.headers['Authorization'], 'Bearer my_token');
    });

    test('does not attach header when token is absent', () async {
      when(() => storage.read(key: 'auth_token')).thenAnswer((_) async => null);
      final interceptor = AuthInterceptor(storage: storage, authViewModel: authViewModel);
      final options = RequestOptions(path: '/test');
      final handler = MockHandler();
      when(() => handler.next(any())).thenReturn(null);

      await interceptor.onRequest(options, handler);

      final captured = verify(() => handler.next(captureAny())).captured.first as RequestOptions;
      expect(captured.headers.containsKey('Authorization'), isFalse);
    });
  });

  group('AuthInterceptor — 401 response', () {
    test('calls logout on AuthViewModel and clears token on 401', () async {
      when(() => storage.delete(key: 'auth_token')).thenAnswer((_) async {});
      when(() => authViewModel.logout()).thenAnswer((_) async {});
      final interceptor = AuthInterceptor(storage: storage, authViewModel: authViewModel);
      final response = Response(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 401,
      );
      final handler = MockResponseHandler();
      when(() => handler.next(any())).thenReturn(null);

      await interceptor.onResponse(response, handler);

      verify(() => storage.delete(key: 'auth_token')).called(1);
      verify(() => authViewModel.logout()).called(1);
    });
  });
}
