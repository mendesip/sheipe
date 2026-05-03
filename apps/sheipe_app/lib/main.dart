import 'package:flutter/material.dart';
import 'core/di/service_locator.dart';
import 'core/sync/sync_service.dart';
import 'features/auth/presentation/viewmodels/auth_state.dart';
import 'features/auth/presentation/viewmodels/auth_view_model.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator.init();

  // Boot the offline-first sync loop when the user is authenticated; stop
  // it on logout so we don't drain the queue with a stale token.
  final auth = sl<AuthViewModel>();
  final sync = sl<SyncService>();
  auth.stream.listen((state) {
    if (state is AuthAuthenticated) {
      sync.start();
    } else if (state is AuthUnauthenticated) {
      sync.stop();
    }
  });

  runApp(const MyApp());
}
