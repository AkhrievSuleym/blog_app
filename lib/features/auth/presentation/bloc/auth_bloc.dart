import 'dart:io';

import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/core/common/entities/user_entity.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/update_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_login.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_out.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSighUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  final UserSignOut _userSignOut;
  final UpdateUser _updateUser;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
    required UserSignOut userSignOut,
    required UpdateUser updateUser,
  })  : _userSighUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        _userSignOut = userSignOut,
        _updateUser = updateUser,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSighUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsLoggedIn>(_isLoggedIn);
    on<UserLoggedOutEvent>(_onUserSignOut);
    on<UserUpdateEvent>(_onUpdateUser);
  }

  void _onUpdateUser(UserUpdateEvent event, Emitter<AuthState> emit) async {
    final params = UpdateUserParams(
      image: event.image,
      name: event.name,
      email: event.email,
      id: event.id,
      blogsCount: event.blogsCount,
    );

    final result = await _updateUser(params);

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(UpdateUserSuccess(user)),
    );
  }

  void _onUserSignOut(UserLoggedOutEvent event, Emitter<AuthState> emit) async {
    final res = await _userSignOut(EmptyParams());
    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (success) => emit(UserLoggedOutState()),
    );
  }

  void _isLoggedIn(AuthIsLoggedIn event, Emitter<AuthState> emit) async {
    final res = await _currentUser(EmptyParams());
    res.fold(
      (failure) {
        emit(AuthFailure(failure.message));
      },
      (user) {
        _emitAuthSuccess(user, emit);
      },
    );
  }

  void _onAuthSighUp(AuthSignUp event, Emitter<AuthState> emit) async {
    final res = await _userSighUp(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
        blogsCount: event.blogsCount,
      ),
    );
    res.fold(
      (failure) {
        emit(
          AuthFailure(failure.message),
        );
      },
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    final res = await _userLogin(
      UserLoginParams(
        email: event.email,
        password: event.password,
      ),
    );
    res.fold(
      (failure) => emit(
        AuthFailure(failure.message),
      ),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _emitAuthSuccess(UserEntity user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
