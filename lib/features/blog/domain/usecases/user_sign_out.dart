import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';

class UserSignOut implements UseCase<void, EmptyParams> {
  final BlogRepository blogRepository;

  UserSignOut(this.blogRepository);

  @override
  Future<Either<Failure, void>> call(EmptyParams params) async {
    return await blogRepository.signOut();
  }
}
