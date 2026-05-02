import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheipe_app/app_router.dart';
import 'package:sheipe_app/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:sheipe_app/features/auth/presentation/viewmodels/auth_state.dart';

class MockAuthViewModel extends Mock implements AuthViewModel {}

void main() {
  late MockAuthViewModel authViewModel;
  late StreamController<AuthState> streamController;

  setUp(() {
    authViewModel = MockAuthViewModel();
    streamController = StreamController<AuthState>.broadcast();
    when(() => authViewModel.stream).thenAnswer((_) => streamController.stream);
  });

  tearDown(() => streamController.close());

  test('AppRouter can be instantiated with AuthViewModel', () {
    when(() => authViewModel.state).thenReturn(const AuthUnauthenticated());
    final appRouter = AppRouter(authViewModel: authViewModel);
    expect(appRouter.router, isNotNull);
  });

  test('AppRouter router has correct initialLocation', () {
    when(() => authViewModel.state).thenReturn(const AuthUnauthenticated());
    final appRouter = AppRouter(authViewModel: authViewModel);
    expect(appRouter.router.routeInformationProvider.value.uri.path, '/');
  });
}
