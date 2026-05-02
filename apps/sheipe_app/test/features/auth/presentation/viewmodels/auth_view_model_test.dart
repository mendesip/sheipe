import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheipe_app/core/network/auth_event.dart';
import 'package:sheipe_app/features/auth/data/repositories/auth_repository.dart';
import 'package:sheipe_app/features/auth/domain/entities/user.dart';
import 'package:sheipe_app/features/auth/presentation/viewmodels/auth_state.dart';
import 'package:sheipe_app/features/auth/presentation/viewmodels/auth_view_model.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

final _testUser = User(
  id: '1',
  name: 'Test User',
  email: 'test@example.com',
  role: 'athlete',
  createdAt: DateTime(2026),
);

void main() {
  setUpAll(() => registerFallbackValue(_testUser));

  late MockAuthRepository mockRepo;
  late StreamController<AuthEvent> eventController;

  setUp(() {
    mockRepo = MockAuthRepository();
    eventController = StreamController<AuthEvent>.broadcast();
    when(() => mockRepo.authEvents).thenAnswer((_) => eventController.stream);
  });

  tearDown(() => eventController.close());

  AuthViewModel buildViewModel() => AuthViewModel(repository: mockRepo);

  group('checkAuthStatus', () {
    blocTest<AuthViewModel, AuthState>(
      'emits AuthAuthenticated when user stored',
      build: buildViewModel,
      setUp: () {
        when(() => mockRepo.checkAuth()).thenAnswer((_) async => _testUser);
      },
      act: (vm) => vm.checkAuthStatus(),
      expect: () => [isA<AuthLoading>(), isA<AuthAuthenticated>()],
    );

    blocTest<AuthViewModel, AuthState>(
      'emits AuthUnauthenticated when no stored user',
      build: buildViewModel,
      setUp: () {
        when(() => mockRepo.checkAuth()).thenAnswer((_) async => null);
      },
      act: (vm) => vm.checkAuthStatus(),
      expect: () => [isA<AuthLoading>(), isA<AuthUnauthenticated>()],
    );
  });

  group('login', () {
    blocTest<AuthViewModel, AuthState>(
      'emits loading then authenticated on success',
      build: buildViewModel,
      setUp: () {
        when(() => mockRepo.login(email: any(named: 'email'), password: any(named: 'password')))
            .thenAnswer((_) async => _testUser);
      },
      act: (vm) => vm.login(email: 'e', password: 'p'),
      expect: () => [isA<AuthLoading>(), isA<AuthAuthenticated>()],
    );

    blocTest<AuthViewModel, AuthState>(
      'emits loading then error on failure',
      build: buildViewModel,
      setUp: () {
        when(() => mockRepo.login(email: any(named: 'email'), password: any(named: 'password')))
            .thenThrow(Exception('Invalid email or password'));
      },
      act: (vm) => vm.login(email: 'e', password: 'wrong'),
      expect: () => [isA<AuthLoading>(), isA<AuthError>()],
    );
  });

  group('register', () {
    blocTest<AuthViewModel, AuthState>(
      'emits loading then authenticated on success',
      build: buildViewModel,
      setUp: () {
        when(() => mockRepo.register(
              name: any(named: 'name'),
              email: any(named: 'email'),
              password: any(named: 'password'),
              passwordConfirmation: any(named: 'passwordConfirmation'),
              role: any(named: 'role'),
            )).thenAnswer((_) async => _testUser);
      },
      act: (vm) => vm.register(
        name: 'Test',
        email: 'e',
        password: 'p',
        passwordConfirmation: 'p',
        role: 'athlete',
      ),
      expect: () => [isA<AuthLoading>(), isA<AuthAuthenticated>()],
    );
  });

  group('logout', () {
    blocTest<AuthViewModel, AuthState>(
      'emits AuthUnauthenticated',
      build: buildViewModel,
      setUp: () {
        when(() => mockRepo.logout()).thenAnswer((_) async {});
      },
      act: (vm) => vm.logout(),
      expect: () => [isA<AuthUnauthenticated>()],
    );
  });

  group('AuthUnauthorized stream event', () {
    blocTest<AuthViewModel, AuthState>(
      'emits AuthUnauthenticated when AuthUnauthorized received',
      build: buildViewModel,
      act: (vm) async {
        await Future.delayed(Duration.zero);
        eventController.add(const AuthUnauthorized());
        await Future.delayed(const Duration(milliseconds: 50));
      },
      expect: () => [isA<AuthUnauthenticated>()],
    );
  });
}
