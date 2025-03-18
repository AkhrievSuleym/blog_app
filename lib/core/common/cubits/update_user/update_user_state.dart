part of 'update_user_cubit.dart';

@immutable
sealed class UpdateUserState {}

final class UpdateUserInitial extends UpdateUserState {}

final class UpdateUserLoading extends UpdateUserState {}

final class UpdateUserFailure extends UpdateUserState {
  final String message;

  UpdateUserFailure(this.message);
}

final class UpdateUserSuccess extends UpdateUserState {
  final UserEntity user;

  UpdateUserSuccess(this.user);
}
