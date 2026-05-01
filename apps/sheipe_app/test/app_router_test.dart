import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheipe_app/app_router.dart';
import 'package:sheipe_app/features/auth/presentation/viewmodels/auth_view_model.dart';

class MockAuthViewModel extends Mock implements AuthViewModel {}

void main() {
  late MockAuthViewModel authViewModel;
  late StreamController<AuthState> streamController;
  late AppRouter appRouter;

  setUp(() {
    authViewModel = MockAuthViewModel();
    streamController = StreamController<AuthState>.broadcast();
    when(() => authViewModel.stream).thenAnswer((_) => streamController.stream);
    appRouter = AppRouter(authViewModel: authViewModel);
  });

  tearDown(() => streamController.close());

  group('AppRouter redirect', () {
    test('redirects to /auth when unauthenticated', () {
      when(() => authViewModel.state).thenReturn(const Unauthenticated());
      final location = appRouter.redirectForState(location: '/home');
      expect(location, '/auth');
    });

    test('allows navigation when authenticated', () {
      when(() => authViewModel.state).thenReturn(const Authenticated());
      final location = appRouter.redirectForState(location: '/home');
      expect(location, isNull);
    });

    test('redirects authenticated user away from /auth to /', () {
      when(() => authViewModel.state).thenReturn(const Authenticated());
      final location = appRouter.redirectForState(location: '/auth');
      expect(location, '/');
    });
  });
}
