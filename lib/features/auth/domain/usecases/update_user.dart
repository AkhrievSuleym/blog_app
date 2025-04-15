import 'dart:io';

import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/core/common/entities/user_entity.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';

class UpdateUser implements UseCase<UserEntity, UpdateUserParams> {
  final AuthRepository authRepository;

  UpdateUser(this.authRepository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateUserParams params) async {
    return await authRepository.updateProfile(
      image: params.image,
      name: params.name,
      email: params.email,
      id: params.id,
      blogsCount: params.blogsCount,
    );
  }
}

class UpdateUserParams {
  final File? image;
  final String name;
  final String email;
  final String id;
  final int blogsCount;

  UpdateUserParams({
    required this.image,
    required this.name,
    required this.email,
    required this.id,
    required this.blogsCount,
  });
}
