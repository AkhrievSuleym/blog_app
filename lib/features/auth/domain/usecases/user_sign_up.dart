import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/core/common/entities/user_entity.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignUp implements UseCase<UserEntity, UserSignUpParams> {
  final AuthRepository authRepository;

  UserSignUp(this.authRepository);

  @override
  Future<Either<Failure, UserEntity>> call(UserSignUpParams params) async {
    return await authRepository.signUp(
        name: params.name,
        email: params.email,
        password: params.password,
        blogsCount: params.blogsCount);
  }
}

class UserSignUpParams {
  final String email;
  final String password;
  final String name;
  final int blogsCount;

  UserSignUpParams({
    required this.email,
    required this.password,
    required this.name,
    required this.blogsCount,
  });
}
