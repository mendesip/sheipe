import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheipe_app/core/network/auth_event.dart';
import 'package:sheipe_app/core/network/interceptors/auth_interceptor.dart';
import 'package:sheipe_app/features/auth/data/local/auth_local_data_source.dart';

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}
class MockHandler extends Mock implements RequestInterceptorHandler {}
class FakeRequestOptions extends Fake implements RequestOptions {}

void main() {
  setUpAll(() => registerFallbackValue(FakeRequestOptions()));

  late MockAuthLocalDataSource mockLocal;
  late StreamController<AuthEvent> eventController;
  late AuthInterceptor interceptor;

  setUp(() {
    mockLocal = MockAuthLocalDataSource();
    eventController = StreamController<AuthEvent>.broadcast();
    interceptor = AuthInterceptor(
      localDataSource: mockLocal,
      authEventSink: eventController.sink,
      baseUrl: 'http://localhost:3000',
    );
  });

  tearDown(() => eventController.close());

  group('onRequest', () {
    test('injects Bearer token when access token present', () async {
      when(() => mockLocal.getAccessToken()).thenAnswer((_) async => 'my_token');
      final options = RequestOptions(path: '/test');
      final handler = MockHandler();
      when(() => handler.next(any())).thenReturn(null);

      await interceptor.onRequest(options, handler);

      final captured = verify(() => handler.next(captureAny())).captured.first as RequestOptions;
      expect(captured.headers['Authorization'], 'Bearer my_token');
    });

    test('does not inject header when no access token', () async {
      when(() => mockLocal.getAccessToken()).thenAnswer((_) async => null);
      final options = RequestOptions(path: '/test');
      final handler = MockHandler();
      when(() => handler.next(any())).thenReturn(null);

      await interceptor.onRequest(options, handler);

      final captured = verify(() => handler.next(captureAny())).captured.first as RequestOptions;
      expect(captured.headers.containsKey('Authorization'), isFalse);
    });
  });
}
