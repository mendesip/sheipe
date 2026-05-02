import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/presentation/screens/splash_screen.dart';
import 'features/auth/presentation/screens/onboarding_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/auth/presentation/screens/profile_screen.dart';
import 'features/auth/presentation/screens/edit_profile_screen.dart';
import 'features/auth/presentation/viewmodels/auth_view_model.dart';
import 'features/auth/presentation/viewmodels/auth_state.dart';
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
      ],
    );
  }

  final AuthViewModel _authViewModel;
  late final GoRouter _router;

  GoRouter get router => _router;

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
