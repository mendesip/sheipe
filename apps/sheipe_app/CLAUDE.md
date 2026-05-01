# CLAUDE.md — sheipe_app

Flutter mobile app for Sheipe. Targets iOS 14+ and Android API 24+.

## Commands

```bash
flutter pub get                                   # Install dependencies
flutter run                                       # Run on connected device/emulator
flutter build apk                                 # Build Android APK
flutter build ios                                 # Build iOS
flutter test                                      # Run all tests
flutter test test/path/to/file_test.dart          # Run a single test
flutter test --coverage                           # Run tests with coverage report
flutter analyze                                   # Lint / static analysis
dart run build_runner build --delete-conflicting-outputs  # Regenerate Drift/generated files
```

## Conventions

- State management via Cubit only, named `*ViewModel` (e.g. `WorkoutViewModel`) — no business logic in widgets
- Repository pattern: every feature has an `abstract *Repository` implemented by `*RepositoryImpl` which composes a `*LocalDataSource` (Drift) and a `*RemoteDataSource` (Dio)
- Drift is the source of truth on the client — write locally first, sync with API in background
- Dependency injection via `get_it` — all dependencies registered in `ServiceLocator.init()`
- Tests use `mocktail` for mocking; `bloc_test` for Cubit tests; minimum 95% coverage

## Architecture

```
lib/
├── core/
│   ├── di/              # ServiceLocator (get_it)
│   ├── network/         # ApiClient (Dio) + AuthInterceptor
│   ├── storage/         # AppDatabase (Drift, zero tables at scaffold)
│   └── repository/      # Abstract contracts: LocalDataSource, RemoteDataSource, BaseRepository
├── features/            # One folder per domain feature
│   └── <feature>/
│       ├── data/        # datasources, repository impl, models
│       ├── domain/      # entities, abstract repos
│       └── presentation/  # screens, viewmodels (cubits), widgets
├── shared/
│   ├── theme/           # AppTheme, AppColors, AppTextStyles (placeholders until design system)
│   └── widgets/         # Cross-feature reusable widgets
├── app_router.dart      # GoRouter with auth guard
└── main.dart            # Entry point
```
