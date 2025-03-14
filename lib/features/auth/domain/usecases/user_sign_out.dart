import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignOut implements UseCase<void, EmptyParams> {
  final AuthRepository authRepository;

  UserSignOut(this.authRepository);

  @override
  Future<Either<Failure, void>> call(EmptyParams params) async {
    return await authRepository.signOut();
  }
}
