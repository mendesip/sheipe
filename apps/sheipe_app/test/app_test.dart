import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheipe_app/app.dart';
import 'package:sheipe_app/app_router.dart';
import 'package:sheipe_app/core/di/service_locator.dart';
import 'package:sheipe_app/core/storage/app_database.dart';
import 'package:sheipe_app/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:sheipe_app/features/auth/presentation/viewmodels/auth_state.dart';

class MockAppDatabase extends Mock implements AppDatabase {}
class MockAuthViewModel extends Mock implements AuthViewModel {}

void main() {
  late MockAuthViewModel authViewModel;
  late StreamController<AuthState> streamController;

  setUp(() {
    sl.reset();
    authViewModel = MockAuthViewModel();
    streamController = StreamController<AuthState>.broadcast();

    when(() => authViewModel.state).thenReturn(const AuthUnauthenticated());
    when(() => authViewModel.stream).thenAnswer((_) => streamController.stream);

    sl.registerLazySingleton<AppDatabase>(() => MockAppDatabase());
    sl.registerLazySingleton<AuthViewModel>(() => authViewModel);
    sl.registerLazySingleton<AppRouter>(() => AppRouter(authViewModel: authViewModel));
  });

  tearDown(() async {
    await streamController.close();
    sl.reset();
  });

  testWidgets('MyApp renders without exceptions', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
