import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheipe_app/core/network/auth_event.dart';
import 'package:sheipe_app/features/auth/data/local/auth_local_data_source.dart';
import 'package:sheipe_app/features/auth/data/remote/auth_remote_data_source.dart';
import 'package:sheipe_app/features/auth/data/repositories/auth_repository.dart';
import 'package:sheipe_app/features/auth/domain/entities/user.dart';

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}
class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

final _dummyUser = User(
  id: '0',
  name: '',
  email: '',
  role: 'athlete',
  createdAt: DateTime(2026),
);

void main() {
  setUpAll(() => registerFallbackValue(_dummyUser));
  late MockAuthLocalDataSource mockLocal;
  late MockAuthRemoteDataSource mockRemote;
  late StreamController<AuthEvent> eventController;
  late AuthRepository repository;

  final testUser = User(
    id: '1',
    name: 'Test',
    email: 'test@example.com',
    role: 'athlete',
    createdAt: DateTime(2026),
  );

  setUp(() {
    mockLocal = MockAuthLocalDataSource();
    mockRemote = MockAuthRemoteDataSource();
    eventController = StreamController<AuthEvent>.broadcast();
    repository = AuthRepository(
      local: mockLocal,
      remote: mockRemote,
      authEventController: eventController,
    );
  });

  tearDown(() => eventController.close());

  group('login', () {
    test('saves tokens and user on success', () async {
      when(() => mockRemote.login(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => (
                tokens: (accessToken: 'acc', refreshToken: 'ref'),
                user: testUser,
              ));
      when(() => mockLocal.saveTokens(accessToken: any(named: 'accessToken'), refreshToken: any(named: 'refreshToken')))
          .thenAnswer((_) async {});
      when(() => mockLocal.saveUser(any())).thenAnswer((_) async {});

      final result = await repository.login(email: 'e', password: 'p');

      expect(result, testUser);
      verify(() => mockLocal.saveTokens(accessToken: 'acc', refreshToken: 'ref')).called(1);
      verify(() => mockLocal.saveUser(testUser)).called(1);
    });
  });

  group('logout', () {
    test('clears tokens locally even if remote throws', () async {
      when(() => mockRemote.logout()).thenThrow(Exception('network error'));
      when(() => mockLocal.clearTokens()).thenAnswer((_) async {});
      when(() => mockLocal.clearUser()).thenAnswer((_) async {});

      await repository.logout();

      verify(() => mockLocal.clearTokens()).called(1);
      verify(() => mockLocal.clearUser()).called(1);
    });
  });

  group('checkAuth', () {
    test('returns user when stored', () async {
      when(() => mockLocal.getUser()).thenAnswer((_) async => testUser);

      final result = await repository.checkAuth();

      expect(result, testUser);
      verifyNever(() => mockRemote.getMe());
    });

    test('returns null when no stored user', () async {
      when(() => mockLocal.getUser()).thenAnswer((_) async => null);

      final result = await repository.checkAuth();

      expect(result, isNull);
    });
  });
}
