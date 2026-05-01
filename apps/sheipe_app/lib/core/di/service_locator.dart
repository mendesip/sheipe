import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../network/interceptors/auth_interceptor.dart';
import '../storage/app_database.dart';
import '../../app_router.dart';
import '../../features/auth/presentation/viewmodels/auth_view_model.dart';

final sl = GetIt.instance;

class ServiceLocator {
  ServiceLocator._(); // coverage:ignore-line

  static Future<void> init() async {
    const storage = FlutterSecureStorage();

    sl.registerLazySingleton<AppDatabase>(
      () => AppDatabase(), // coverage:ignore-line
      dispose: (db) => db.close(), // coverage:ignore-line
    );

    sl.registerLazySingleton<AuthViewModel>(
      () => AuthViewModel(storage: storage),
    );

    sl.registerLazySingleton<AuthInterceptor>(
      () => AuthInterceptor(storage: storage, authViewModel: sl<AuthViewModel>()),
    );

    sl.registerLazySingleton<ApiClient>(
      () => ApiClient(
        baseUrl: const String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:3000'),
        authInterceptor: sl<AuthInterceptor>(),
      ),
    );

    sl.registerLazySingleton<AppRouter>(
      () => AppRouter(authViewModel: sl<AuthViewModel>()),
    );
  }
}
