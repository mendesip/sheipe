import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheipe_app/features/auth/presentation/viewmodels/auth_view_model.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockSecureStorage storage;

  setUp(() {
    storage = MockSecureStorage();
  });

  group('AuthViewModel', () {
    blocTest<AuthViewModel, AuthState>(
      'emits Unauthenticated when no token stored',
      build: () {
        when(() => storage.read(key: 'auth_token')).thenAnswer((_) async => null);
        return AuthViewModel(storage: storage);
      },
      act: (vm) => vm.checkAuthStatus(),
      expect: () => [isA<Unauthenticated>()],
    );

    blocTest<AuthViewModel, AuthState>(
      'emits Authenticated when token is present',
      build: () {
        when(() => storage.read(key: 'auth_token')).thenAnswer((_) async => 'valid_token');
        return AuthViewModel(storage: storage);
      },
      act: (vm) => vm.checkAuthStatus(),
      expect: () => [isA<Authenticated>()],
    );

    blocTest<AuthViewModel, AuthState>(
      'emits Unauthenticated after logout clears token',
      build: () {
        when(() => storage.read(key: 'auth_token')).thenAnswer((_) async => 'valid_token');
        when(() => storage.delete(key: 'auth_token')).thenAnswer((_) async {});
        return AuthViewModel(storage: storage);
      },
      act: (vm) async {
        await vm.checkAuthStatus();
        await vm.logout();
      },
      expect: () => [isA<Authenticated>(), isA<Unauthenticated>()],
    );
  });
}
