import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/presentation/screens/auth_screen.dart';
import 'features/auth/presentation/viewmodels/auth_view_model.dart';
import 'shared/widgets/main_shell.dart';

class AppRouter {
  AppRouter({required AuthViewModel authViewModel}) : _authViewModel = authViewModel {
    _router = GoRouter(
      initialLocation: '/',
      refreshListenable: _AuthListenable(authViewModel),
      redirect: (context, state) => redirectForState(location: state.matchedLocation),
      routes: [
        ShellRoute(
          builder: (context, state, child) => MainShell(child: child),
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const _MainPlaceholder(),
            ),
          ],
        ),
        GoRoute(
          path: '/auth',
          builder: (context, state) => const AuthScreen(),
        ),
      ],
    );
  }

  final AuthViewModel _authViewModel;
  late final GoRouter _router;

  GoRouter get router => _router;

  String? redirectForState({required String location}) {
    final isAuth = _authViewModel.state is Authenticated;
    final isOnAuth = location == '/auth';

    if (!isAuth && !isOnAuth) return '/auth';
    if (isAuth && isOnAuth) return '/';
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

class _MainPlaceholder extends StatelessWidget {
  const _MainPlaceholder();

  @override
  Widget build(BuildContext context) => const Center(child: Text('Main — placeholder'));
}
