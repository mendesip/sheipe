import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'core/di/service_locator.dart';
import 'features/auth/presentation/screens/splash_screen.dart';
import 'features/auth/presentation/screens/onboarding_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/auth/presentation/screens/profile_screen.dart';
import 'features/auth/presentation/screens/edit_profile_screen.dart';
import 'features/auth/presentation/viewmodels/auth_view_model.dart';
import 'features/auth/presentation/viewmodels/auth_state.dart';
import 'features/exercise/domain/entities/exercise.dart';
import 'features/exercise/presentation/screens/exercise_detail_screen.dart';
import 'features/exercise/presentation/screens/exercise_form_screen.dart';
import 'features/exercise/presentation/screens/exercise_library_screen.dart';
import 'features/exercise/presentation/viewmodels/exercise_view_model.dart';
import 'features/routine/presentation/screens/exercise_picker_screen.dart';
import 'features/routine/presentation/screens/routine_detail_screen.dart';
import 'features/routine/presentation/screens/routine_form_screen.dart';
import 'features/routine/presentation/screens/routines_list_screen.dart';
import 'features/routine/presentation/viewmodels/routine_view_model.dart';
import 'features/workout/presentation/screens/active_workout_screen.dart';
import 'features/workout/presentation/screens/start_workout_screen.dart';
import 'features/workout/presentation/screens/workout_detail_screen.dart';
import 'features/workout/presentation/screens/workout_history_screen.dart';
import 'features/workout/presentation/screens/workout_summary_screen.dart';
import 'features/workout/presentation/viewmodels/active_workout_view_model.dart';
import 'features/workout/presentation/viewmodels/workout_history_view_model.dart';
import 'shared/widgets/main_shell.dart';

class AppRouter {
  AppRouter({required AuthViewModel authViewModel}) : _authViewModel = authViewModel {
    _router = GoRouter(
      initialLocation: '/',
      refreshListenable: _AuthListenable(authViewModel),
      redirect: (context, state) => _redirect(state),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => BlocProvider.value(
            value: _authViewModel,
            child: const SplashScreen(),
          ),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/auth/login',
          builder: (context, state) => BlocProvider.value(
            value: _authViewModel,
            child: const LoginScreen(),
          ),
        ),
        GoRoute(
          path: '/auth/register',
          builder: (context, state) => BlocProvider.value(
            value: _authViewModel,
            child: const RegisterScreen(),
          ),
        ),
        ShellRoute(
          builder: (context, state, child) => MainShell(child: child),
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const _HomePlaceholder(),
            ),
          ],
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => BlocProvider.value(
            value: _authViewModel,
            child: const ProfileScreen(),
          ),
        ),
        GoRoute(
          path: '/profile/edit',
          builder: (context, state) => BlocProvider.value(
            value: _authViewModel,
            child: const EditProfileScreen(),
          ),
        ),

        // ── Exercises ──────────────────────────────────────────────
        GoRoute(
          path: '/exercises',
          builder: (context, state) => _exerciseScope(const ExerciseLibraryScreen()),
        ),
        GoRoute(
          path: '/exercises/new',
          builder: (context, state) => _exerciseScope(const ExerciseFormScreen()),
        ),
        GoRoute(
          path: '/exercises/:id',
          builder: (context, state) => _exerciseScope(
            ExerciseDetailScreen(exerciseId: state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: '/exercises/:id/edit',
          builder: (context, state) {
            final existing = state.extra is Exercise ? state.extra as Exercise : null;
            return _exerciseScope(ExerciseFormScreen(existing: existing));
          },
        ),

        // ── Routines ───────────────────────────────────────────────
        GoRoute(
          path: '/routines',
          builder: (context, state) => _routineScope(const RoutinesListScreen()),
        ),
        GoRoute(
          path: '/routines/new',
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider<RoutineViewModel>.value(value: sl<RoutineViewModel>()),
              BlocProvider<AuthViewModel>.value(value: _authViewModel),
            ],
            child: const RoutineFormScreen(),
          ),
        ),
        GoRoute(
          path: '/routines/:id',
          builder: (context, state) => _routineScope(
            RoutineDetailScreen(routineId: state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: '/routines/:id/exercises/pick',
          builder: (context, state) => _exerciseScope(const ExercisePickerScreen()),
        ),

        // ── Workouts ───────────────────────────────────────────────
        GoRoute(
          path: '/workouts',
          builder: (context, state) => _workoutHistoryScope(const WorkoutHistoryScreen()),
        ),
        GoRoute(
          path: '/workouts/new',
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider<RoutineViewModel>.value(value: sl<RoutineViewModel>()),
              BlocProvider<AuthViewModel>.value(value: _authViewModel),
              BlocProvider<ActiveWorkoutViewModel>.value(value: sl<ActiveWorkoutViewModel>()),
            ],
            child: const StartWorkoutScreen(),
          ),
        ),
        GoRoute(
          path: '/workouts/:id/active',
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider<ActiveWorkoutViewModel>.value(value: sl<ActiveWorkoutViewModel>()),
              BlocProvider<ExerciseViewModel>.value(value: sl<ExerciseViewModel>()),
            ],
            child: ActiveWorkoutScreen(workoutId: state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: '/workouts/:id/summary',
          builder: (context, state) => BlocProvider<ActiveWorkoutViewModel>.value(
            value: sl<ActiveWorkoutViewModel>(),
            child: WorkoutSummaryScreen(workoutId: state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: '/workouts/:id',
          builder: (context, state) => _workoutHistoryScope(
            WorkoutDetailScreen(workoutId: state.pathParameters['id']!),
          ),
        ),
      ],
    );
  }

  final AuthViewModel _authViewModel;
  late final GoRouter _router;

  GoRouter get router => _router;

  Widget _exerciseScope(Widget child) => BlocProvider<ExerciseViewModel>.value(
        value: sl<ExerciseViewModel>(),
        child: child,
      );

  Widget _routineScope(Widget child) => BlocProvider<RoutineViewModel>.value(
        value: sl<RoutineViewModel>(),
        child: child,
      );

  Widget _workoutHistoryScope(Widget child) => BlocProvider<WorkoutHistoryViewModel>.value(
        value: sl<WorkoutHistoryViewModel>(),
        child: child,
      );

  String? _redirect(GoRouterState state) {
    final authState = _authViewModel.state;
    final location = state.matchedLocation;

    final isOnSplash = location == '/';
    final isOnAuth = location.startsWith('/auth') || location == '/onboarding';

    if (authState is AuthInitial || authState is AuthLoading) {
      return isOnSplash ? null : '/';
    }

    if (authState is AuthAuthenticated) {
      if (isOnAuth || isOnSplash) return '/home';
      return null;
    }

    if (authState is AuthUnauthenticated || authState is AuthError) {
      if (isOnAuth) return null;
      return '/auth/login';
    }

    return null;
  }
}

class _AuthListenable extends ChangeNotifier {
  _AuthListenable(AuthViewModel viewModel) {
    _subscription = viewModel.stream.listen((_) => notifyListeners());
  }

  late final dynamic _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class _HomePlaceholder extends StatelessWidget {
  const _HomePlaceholder();

  @override
  Widget build(BuildContext context) => const Center(child: Text('Home — placeholder'));
}
