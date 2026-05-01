import 'package:flutter_test/flutter_test.dart';
import 'package:sheipe_app/app_router.dart';
import 'package:sheipe_app/core/di/service_locator.dart';
import 'package:sheipe_app/core/network/api_client.dart';
import 'package:sheipe_app/core/network/interceptors/auth_interceptor.dart';
import 'package:sheipe_app/core/storage/app_database.dart';
import 'package:sheipe_app/features/auth/presentation/viewmodels/auth_view_model.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    sl.reset();
  });

  tearDown(() => sl.reset());

  test('ServiceLocator.init registers all required dependencies', () async {
    await ServiceLocator.init();

    expect(sl.isRegistered<AppDatabase>(), isTrue);
    expect(sl.isRegistered<AuthViewModel>(), isTrue);
    expect(sl.isRegistered<AuthInterceptor>(), isTrue);
    expect(sl.isRegistered<ApiClient>(), isTrue);
    expect(sl.isRegistered<AppRouter>(), isTrue);
  });

  test('ServiceLocator resolves non-platform singletons correctly', () async {
    await ServiceLocator.init();

    final vm = sl<AuthViewModel>();
    expect(vm, isA<AuthViewModel>());

    final interceptor = sl<AuthInterceptor>();
    expect(interceptor, isA<AuthInterceptor>());

    final client = sl<ApiClient>();
    expect(client, isA<ApiClient>());

    final router = sl<AppRouter>();
    expect(router, isA<AppRouter>());
  });

  test('ServiceLocator AuthViewModel is a lazySingleton (same instance)', () async {
    await ServiceLocator.init();
    final vm1 = sl<AuthViewModel>();
    final vm2 = sl<AuthViewModel>();
    expect(identical(vm1, vm2), isTrue);
  });

  test('ServiceLocator AppRouter is a lazySingleton', () async {
    await ServiceLocator.init();
    final r1 = sl<AppRouter>();
    final r2 = sl<AppRouter>();
    expect(identical(r1, r2), isTrue);
  });
}
