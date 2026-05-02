import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheipe_app/core/network/api_client.dart';
import 'package:sheipe_app/core/network/auth_event.dart';
import 'package:sheipe_app/core/network/interceptors/auth_interceptor.dart';
import 'package:sheipe_app/features/auth/data/local/auth_local_data_source.dart';

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late StreamController<AuthEvent> eventController;

  setUp(() {
    eventController = StreamController<AuthEvent>.broadcast();
  });

  tearDown(() => eventController.close());

  AuthInterceptor buildInterceptor() => AuthInterceptor(
        localDataSource: MockAuthLocalDataSource(),
        authEventSink: eventController.sink,
        baseUrl: 'http://localhost:3000',
      );

  test('ApiClient creates Dio with baseUrl and auth interceptor', () {
    final client = ApiClient(
      baseUrl: 'http://localhost:3000',
      authInterceptor: buildInterceptor(),
    );

    expect(client.dio.options.baseUrl, 'http://localhost:3000');
    expect(client.dio.interceptors.whereType<AuthInterceptor>().length, 1);
  });

  test('ApiClient sets correct headers and timeouts', () {
    final client = ApiClient(
      baseUrl: 'http://api.test',
      authInterceptor: buildInterceptor(),
    );

    expect(client.dio.options.headers['Accept'], 'application/json');
    expect(client.dio.options.headers['Content-Type'], 'application/json');
    expect(client.dio.options.connectTimeout, const Duration(seconds: 10));
    expect(client.dio.options.receiveTimeout, const Duration(seconds: 30));
  });
}
