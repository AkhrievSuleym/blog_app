part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  final String email;
  final String password;
  final String name;

  AuthSignUp({
    required this.email,
    required this.password,
    required this.name,
  });
}

final class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin({
    required this.email,
    required this.password,
  });
}

final class AuthIsLoggedIn extends AuthEvent {}

final class UserLoggedOutEvent extends AuthEvent {}

final class UserUpdateEvent extends AuthEvent {
  final File image;
  final String name;
  final String email;
  final String id;

  UserUpdateEvent({
    required this.image,
    required this.name,
    required this.email,
    required this.id,
  });
}
