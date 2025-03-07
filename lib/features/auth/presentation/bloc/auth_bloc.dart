import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSighUp;
  AuthBloc({required UserSignUp userSignUp})
      : _userSighUp = userSignUp,
        super(AuthInitial()) {
    on<AuthSignUp>((event, emit) async {
      final res = await _userSighUp(UserSignUpParams(
          email: event.email, password: event.password, name: event.name));
      res.fold((failure) => emit(AuthFailure(failure.message)),
          (uId) => emit(AuthSuccess(uId)));
    });
  }
}
