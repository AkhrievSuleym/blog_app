import 'dart:io';

import 'package:blog_app/core/common/entities/user_entity.dart';
import 'package:blog_app/features/auth/domain/usecases/update_user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'update_user_state.dart';

class UpdateUserCubit extends Cubit<UpdateUserState> {
  final UpdateUser updateUser;

  UpdateUserCubit(this.updateUser) : super(UpdateUserInitial());

  Future<void> updateUserProfile({
    required File image,
    required String name,
    required String email,
    required String id,
  }) async {
    emit(UpdateUserLoading());

    final params = UpdateUserParams(
      image: image,
      name: name,
      email: email,
      id: id,
    );

    final result = await updateUser(params);

    result.fold(
      (failure) => emit(UpdateUserFailure(failure.message)),
      (user) => emit(UpdateUserSuccess(user)),
    );
  }
}
