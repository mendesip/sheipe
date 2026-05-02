import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../network/auth_event.dart';
import '../network/interceptors/auth_interceptor.dart';
import '../storage/app_database.dart';
import '../../app_router.dart';
import '../../features/auth/data/local/auth_local_data_source.dart';
import '../../features/auth/data/remote/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/presentation/viewmodels/auth_view_model.dart';

final sl = GetIt.instance;

class ServiceLocator {
  ServiceLocator._(); // coverage:ignore-line

  static Future<void> init() async {
    const baseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:3000');

    sl.registerLazySingleton<AppDatabase>(
      () => AppDatabase(), // coverage:ignore-line
      dispose: (db) => db.close(), // coverage:ignore-line
    );

    final authEventController = StreamController<AuthEvent>.broadcast();
    sl.registerSingleton<StreamController<AuthEvent>>(authEventController);

    const storage = FlutterSecureStorage();
    final localDataSource = AuthLocalDataSource(storage: storage);
    sl.registerSingleton<AuthLocalDataSource>(localDataSource);

    sl.registerLazySingleton<AuthInterceptor>(
      () => AuthInterceptor(
        localDataSource: localDataSource,
        authEventSink: authEventController.sink,
        baseUrl: baseUrl,
      ),
    );

    sl.registerLazySingleton<ApiClient>(
      () => ApiClient(
        baseUrl: baseUrl,
        authInterceptor: sl<AuthInterceptor>(),
      ),
    );

    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(dio: sl<ApiClient>().dio),
    );

    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepository(
        local: localDataSource,
        remote: sl<AuthRemoteDataSource>(),
        authEventController: authEventController,
      ),
    );

    sl.registerLazySingleton<AuthViewModel>(
      () => AuthViewModel(repository: sl<AuthRepository>()),
      dispose: (vm) => vm.close(),
    );

    sl.registerLazySingleton<AppRouter>(
      () => AppRouter(authViewModel: sl<AuthViewModel>()),
    );
  }
}
