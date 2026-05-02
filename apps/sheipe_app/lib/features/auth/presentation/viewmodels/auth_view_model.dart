import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/auth_event.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthViewModel extends Cubit<AuthState> {
  AuthViewModel({required AuthRepository repository})
      : _repository = repository,
        super(const AuthInitial()) {
    _eventSubscription = repository.authEvents.listen(_onAuthEvent);
  }

  final AuthRepository _repository;
  late final StreamSubscription<AuthEvent> _eventSubscription;

  void _onAuthEvent(AuthEvent event) {
    if (event is AuthUnauthorized) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());
    final user = await _repository.checkAuth();
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.login(email: email, password: password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String role,
  }) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        role: role,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(const AuthUnauthenticated());
  }

  Future<void> updateProfile({required String name}) async {
    try {
      final user = await _repository.updateProfile(name: name);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _eventSubscription.cancel();
    return super.close();
  }
}
