part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}

final class UserLoggedOutState extends AuthState {}

final class AuthSuccess extends AuthState {
  final UserEntity user;

  AuthSuccess(this.user);
}

final class UpdateUserSuccess extends AuthState {
  final UserEntity user;

  UpdateUserSuccess(this.user);
}
