import 'dart:async';
import '../../../../core/network/auth_event.dart';
import '../local/auth_local_data_source.dart';
import '../remote/auth_remote_data_source.dart';
import '../../domain/entities/user.dart';

class AuthRepository {
  AuthRepository({
    required AuthLocalDataSource local,
    required AuthRemoteDataSource remote,
    required StreamController<AuthEvent> authEventController,
  })  : _local = local,
        _remote = remote,
        _authEventController = authEventController;

  final AuthLocalDataSource _local;
  final AuthRemoteDataSource _remote;
  final StreamController<AuthEvent> _authEventController;

  Stream<AuthEvent> get authEvents => _authEventController.stream;

  Future<User> login({required String email, required String password}) async {
    final result = await _remote.login(email: email, password: password);
    await Future.wait([
      _local.saveTokens(
        accessToken: result.tokens.accessToken,
        refreshToken: result.tokens.refreshToken,
      ),
      _local.saveUser(result.user),
    ]);
    return result.user;
  }

  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String role,
  }) async {
    final result = await _remote.register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      role: role,
    );
    await Future.wait([
      _local.saveTokens(
        accessToken: result.tokens.accessToken,
        refreshToken: result.tokens.refreshToken,
      ),
      _local.saveUser(result.user),
    ]);
    return result.user;
  }

  Future<void> logout() async {
    try {
      await _remote.logout();
    } catch (_) {}
    await Future.wait([
      _local.clearTokens(),
      _local.clearUser(),
    ]);
  }

  Future<User?> checkAuth() => _local.getUser();

  Future<User> updateProfile({required String name}) async {
    final user = await _remote.updateMe(name: name);
    await _local.saveUser(user);
    return user;
  }
}
