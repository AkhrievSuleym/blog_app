import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/auth/domain/entities/user_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserEntity>> signUp(
      {required String name, required String email, required String password});

  Future<Either<Failure, UserEntity>> login(
      {required String email, required String password});
}
