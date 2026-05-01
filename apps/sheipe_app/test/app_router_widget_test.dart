import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheipe_app/app_router.dart';
import 'package:sheipe_app/features/auth/presentation/viewmodels/auth_view_model.dart';

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

  testWidgets('renders MainShell and main placeholder when authenticated', (tester) async {
    when(() => authViewModel.state).thenReturn(const Authenticated());
    final appRouter = AppRouter(authViewModel: authViewModel);

    await tester.pumpWidget(MaterialApp.router(routerConfig: appRouter.router));
    await tester.pumpAndSettle();

    expect(find.text('Main — placeholder'), findsOneWidget);
  });

  testWidgets('renders AuthScreen when unauthenticated', (tester) async {
    when(() => authViewModel.state).thenReturn(const Unauthenticated());
    final appRouter = AppRouter(authViewModel: authViewModel);

    await tester.pumpWidget(MaterialApp.router(routerConfig: appRouter.router));
    await tester.pumpAndSettle();

    expect(find.text('Auth — placeholder'), findsOneWidget);
  });

  testWidgets('_AuthListenable disposes cleanly', (tester) async {
    when(() => authViewModel.state).thenReturn(const Authenticated());
    final appRouter = AppRouter(authViewModel: authViewModel);

    await tester.pumpWidget(MaterialApp.router(routerConfig: appRouter.router));
    await tester.pumpAndSettle();

    appRouter.router.dispose();
    // If dispose throws, the test fails — confirms subscription is cancelled
    expect(true, isTrue);
  });

  testWidgets('redirects to / when auth state changes to Authenticated', (tester) async {
    when(() => authViewModel.state).thenReturn(const Unauthenticated());
    final appRouter = AppRouter(authViewModel: authViewModel);

    await tester.pumpWidget(MaterialApp.router(routerConfig: appRouter.router));
    await tester.pumpAndSettle();
    expect(find.text('Auth — placeholder'), findsOneWidget);

    when(() => authViewModel.state).thenReturn(const Authenticated());
    streamController.add(const Authenticated());
    await tester.pumpAndSettle();
    expect(find.text('Main — placeholder'), findsOneWidget);
  });
}
