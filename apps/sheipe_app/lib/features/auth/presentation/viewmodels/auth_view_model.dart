import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'auth_state.dart';

class AuthViewModel extends Cubit<AuthState> {
  AuthViewModel({required FlutterSecureStorage storage})
      : _storage = storage,
        super(const Unauthenticated());

  final FlutterSecureStorage _storage;
  static const _tokenKey = 'auth_token';

  Future<void> checkAuthStatus() async {
    final token = await _storage.read(key: _tokenKey);
    emit(token != null && token.isNotEmpty ? const Authenticated() : const Unauthenticated());
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    emit(const Unauthenticated());
  }
}
