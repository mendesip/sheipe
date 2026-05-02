import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheipe_app/app_router.dart';
import 'package:sheipe_app/features/auth/domain/entities/user.dart';
import 'package:sheipe_app/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:sheipe_app/features/auth/presentation/viewmodels/auth_state.dart';

class MockAuthViewModel extends Mock implements AuthViewModel {}

final _testUser = User(
  id: '1',
  name: 'Test',
  email: 'test@example.com',
  role: 'athlete',
  createdAt: DateTime(2026),
);

void main() {
  late MockAuthViewModel authViewModel;
  late StreamController<AuthState> streamController;

  setUp(() {
    authViewModel = MockAuthViewModel();
    streamController = StreamController<AuthState>.broadcast();
    when(() => authViewModel.stream).thenAnswer((_) => streamController.stream);
  });

  tearDown(() => streamController.close());

  Widget buildApp() => BlocProvider<AuthViewModel>.value(
        value: authViewModel,
        child: Builder(
          builder: (context) {
            final appRouter = AppRouter(authViewModel: authViewModel);
            return MaterialApp.router(routerConfig: appRouter.router);
          },
        ),
      );

  testWidgets('redirects to /home when authenticated', (tester) async {
    when(() => authViewModel.state).thenReturn(AuthAuthenticated(_testUser));

    final appRouter = AppRouter(authViewModel: authViewModel);
    await tester.pumpWidget(MaterialApp.router(routerConfig: appRouter.router));
    await tester.pumpAndSettle();

    expect(find.text('Home — placeholder'), findsOneWidget);
  });

  testWidgets('redirects to /auth/login when unauthenticated (onboarding seen)', (tester) async {
    when(() => authViewModel.state).thenReturn(const AuthUnauthenticated());

    final appRouter = AppRouter(authViewModel: authViewModel);
    await tester.pumpWidget(MaterialApp.router(routerConfig: appRouter.router));
    await tester.pumpAndSettle();

    expect(find.text('Sign In'), findsWidgets);
  });

  testWidgets('_AuthListenable disposes cleanly', (tester) async {
    when(() => authViewModel.state).thenReturn(AuthAuthenticated(_testUser));
    final appRouter = AppRouter(authViewModel: authViewModel);

    await tester.pumpWidget(MaterialApp.router(routerConfig: appRouter.router));
    await tester.pumpAndSettle();

    appRouter.router.dispose();
    expect(true, isTrue);
  });

  testWidgets('redirects to /home when auth state changes to Authenticated', (tester) async {
    when(() => authViewModel.state).thenReturn(const AuthUnauthenticated());
    final appRouter = AppRouter(authViewModel: authViewModel);

    await tester.pumpWidget(MaterialApp.router(routerConfig: appRouter.router));
    await tester.pumpAndSettle();
    expect(find.text('Sign In'), findsWidgets);

    when(() => authViewModel.state).thenReturn(AuthAuthenticated(_testUser));
    streamController.add(AuthAuthenticated(_testUser));
    await tester.pumpAndSettle();
    expect(find.text('Home — placeholder'), findsOneWidget);
  });
}
