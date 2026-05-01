import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/service_locator.dart';
import 'features/auth/presentation/viewmodels/auth_view_model.dart';
import 'app_router.dart';
import 'shared/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthViewModel>(
      create: (_) => sl<AuthViewModel>(),
      child: Builder(
        builder: (context) {
          final router = sl<AppRouter>().router;
          return MaterialApp.router(
            title: 'Sheipe',
            theme: AppTheme.light,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
