import 'package:blog_app/core/common/entities/blog_entity.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';

class GetAllBlogsById
    implements UseCase<List<BlogEntity>, GetAllBlogsByIdParams> {
  final BlogRepository blogRepository;

  GetAllBlogsById(this.blogRepository);

  @override
  Future<Either<Failure, List<BlogEntity>>> call(
      GetAllBlogsByIdParams params) async {
    return await blogRepository.getAllBlogsById(userId: params.userId);
  }
}

class GetAllBlogsByIdParams {
  final String userId;

  GetAllBlogsByIdParams({required this.userId});
}
