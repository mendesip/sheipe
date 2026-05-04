import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../network/auth_event.dart';
import '../network/interceptors/auth_interceptor.dart';
import '../storage/app_database.dart';
import '../sync/sync_queue.dart';
import '../sync/sync_service.dart';
import '../../app_router.dart';
import '../../features/auth/data/local/auth_local_data_source.dart';
import '../../features/auth/data/remote/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/presentation/viewmodels/auth_view_model.dart';
import '../../features/exercise/data/local/exercise_local_data_source.dart';
import '../../features/exercise/data/remote/exercise_remote_data_source.dart';
import '../../features/exercise/data/repositories/exercise_repository.dart';
import '../../features/exercise/presentation/viewmodels/exercise_view_model.dart';
import '../../features/routine/data/local/routine_local_data_source.dart';
import '../../features/routine/data/remote/routine_remote_data_source.dart';
import '../../features/routine/data/repositories/routine_repository.dart';
import '../../features/routine/presentation/viewmodels/routine_view_model.dart';
import '../../features/workout/data/local/workout_local_data_source.dart';
import '../../features/workout/data/remote/workout_remote_data_source.dart';
import '../../features/workout/data/repositories/workout_repository.dart';
import '../../features/workout/presentation/viewmodels/active_workout_view_model.dart';
import '../../features/workout/presentation/viewmodels/workout_history_view_model.dart';

final sl = GetIt.instance;

class ServiceLocator {
  ServiceLocator._(); // coverage:ignore-line

  static Future<void> init() async {
    const baseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://app:3000',
    );

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
      () => ApiClient(baseUrl: baseUrl, authInterceptor: sl<AuthInterceptor>()),
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

    // ── Sync infrastructure ──────────────────────────────────────
    sl.registerLazySingleton<SyncQueue>(() => SyncQueue(db: sl<AppDatabase>()));

    // ── Exercise feature ─────────────────────────────────────────
    sl.registerLazySingleton<ExerciseLocalDataSource>(
      () => ExerciseLocalDataSource(db: sl<AppDatabase>()),
    );
    sl.registerLazySingleton<ExerciseRemoteDataSource>(
      () => ExerciseRemoteDataSource(dio: sl<ApiClient>().dio),
    );
    sl.registerLazySingleton<ExerciseRepository>(
      () => ExerciseRepository(
        local: sl<ExerciseLocalDataSource>(),
        remote: sl<ExerciseRemoteDataSource>(),
        queue: sl<SyncQueue>(),
      ),
    );
    sl.registerLazySingleton<ExerciseViewModel>(
      () => ExerciseViewModel(repository: sl<ExerciseRepository>()),
      dispose: (vm) => vm.close(),
    );

    // ── Routine feature ──────────────────────────────────────────
    sl.registerLazySingleton<RoutineLocalDataSource>(
      () => RoutineLocalDataSource(db: sl<AppDatabase>()),
    );
    sl.registerLazySingleton<RoutineRemoteDataSource>(
      () => RoutineRemoteDataSource(dio: sl<ApiClient>().dio),
    );
    sl.registerLazySingleton<RoutineRepository>(
      () => RoutineRepository(
        local: sl<RoutineLocalDataSource>(),
        remote: sl<RoutineRemoteDataSource>(),
        queue: sl<SyncQueue>(),
      ),
    );
    sl.registerLazySingleton<RoutineViewModel>(
      () => RoutineViewModel(repository: sl<RoutineRepository>()),
      dispose: (vm) => vm.close(),
    );

    // ── Workout feature ──────────────────────────────────────────
    sl.registerLazySingleton<WorkoutLocalDataSource>(
      () => WorkoutLocalDataSource(db: sl<AppDatabase>()),
    );
    sl.registerLazySingleton<WorkoutRemoteDataSource>(
      () => WorkoutRemoteDataSource(dio: sl<ApiClient>().dio),
    );
    sl.registerLazySingleton<WorkoutRepository>(
      () => WorkoutRepository(
        local: sl<WorkoutLocalDataSource>(),
        remote: sl<WorkoutRemoteDataSource>(),
        queue: sl<SyncQueue>(),
      ),
    );
    sl.registerLazySingleton<ActiveWorkoutViewModel>(
      () => ActiveWorkoutViewModel(repository: sl<WorkoutRepository>()),
      dispose: (vm) => vm.close(),
    );
    sl.registerLazySingleton<WorkoutHistoryViewModel>(
      () => WorkoutHistoryViewModel(repository: sl<WorkoutRepository>()),
      dispose: (vm) => vm.close(),
    );

    sl.registerLazySingleton<SyncService>(
      () => SyncService(
        queue: sl<SyncQueue>(),
        exerciseRemote: sl<ExerciseRemoteDataSource>(),
        routineRemote: sl<RoutineRemoteDataSource>(),
        workoutRemote: sl<WorkoutRemoteDataSource>(),
      ),
      dispose: (s) => s.stop(),
    );

    sl.registerLazySingleton<AppRouter>(
      () => AppRouter(authViewModel: sl<AuthViewModel>()),
    );
  }
}
