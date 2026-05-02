sealed class AuthEvent {
  const AuthEvent();
}

final class AuthUnauthorized extends AuthEvent {
  const AuthUnauthorized();
}
