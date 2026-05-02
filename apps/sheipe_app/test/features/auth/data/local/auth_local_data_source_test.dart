import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheipe_app/features/auth/data/local/auth_local_data_source.dart';
import 'package:sheipe_app/features/auth/domain/entities/user.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage mockStorage;
  late AuthLocalDataSource dataSource;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    dataSource = AuthLocalDataSource(storage: mockStorage);
  });

  group('saveTokens', () {
    test('writes access and refresh tokens to storage', () async {
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      await dataSource.saveTokens(
        accessToken: 'access-123',
        refreshToken: 'refresh-456',
      );

      verify(() => mockStorage.write(key: 'auth_access_token', value: 'access-123')).called(1);
      verify(() => mockStorage.write(key: 'auth_refresh_token', value: 'refresh-456')).called(1);
    });
  });

  group('clearTokens', () {
    test('deletes access and refresh tokens from storage', () async {
      when(() => mockStorage.delete(key: any(named: 'key'))).thenAnswer((_) async {});

      await dataSource.clearTokens();

      verify(() => mockStorage.delete(key: 'auth_access_token')).called(1);
      verify(() => mockStorage.delete(key: 'auth_refresh_token')).called(1);
    });
  });

  group('saveUser / getUser', () {
    final user = User(
      id: '1',
      name: 'Test',
      email: 'test@example.com',
      role: 'athlete',
      createdAt: DateTime(2026),
    );

    test('saveUser writes JSON to storage', () async {
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      await dataSource.saveUser(user);

      verify(
        () => mockStorage.write(
          key: 'auth_user_json',
          value: json.encode(user.toJson()),
        ),
      ).called(1);
    });

    test('getUser returns User from storage', () async {
      when(() => mockStorage.read(key: 'auth_user_json'))
          .thenAnswer((_) async => json.encode(user.toJson()));

      final result = await dataSource.getUser();

      expect(result?.id, user.id);
      expect(result?.name, user.name);
    });

    test('getUser returns null when storage is empty', () async {
      when(() => mockStorage.read(key: 'auth_user_json')).thenAnswer((_) async => null);

      final result = await dataSource.getUser();

      expect(result, isNull);
    });
  });

  group('onboarding flag', () {
    test('markOnboardingSeen writes "true"', () async {
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      await dataSource.markOnboardingSeen();

      verify(() => mockStorage.write(key: 'onboarding_seen', value: 'true')).called(1);
    });

    test('isOnboardingSeen returns true when flag set', () async {
      when(() => mockStorage.read(key: 'onboarding_seen')).thenAnswer((_) async => 'true');

      expect(await dataSource.isOnboardingSeen(), isTrue);
    });

    test('isOnboardingSeen returns false when flag not set', () async {
      when(() => mockStorage.read(key: 'onboarding_seen')).thenAnswer((_) async => null);

      expect(await dataSource.isOnboardingSeen(), isFalse);
    });
  });

  group('getAccessToken', () {
    test('returns token from storage', () async {
      when(() => mockStorage.read(key: 'auth_access_token')).thenAnswer((_) async => 'tok');

      expect(await dataSource.getAccessToken(), 'tok');
    });
  });

  group('getRefreshToken', () {
    test('returns token from storage', () async {
      when(() => mockStorage.read(key: 'auth_refresh_token')).thenAnswer((_) async => 'ref');

      expect(await dataSource.getRefreshToken(), 'ref');
    });
  });
}
