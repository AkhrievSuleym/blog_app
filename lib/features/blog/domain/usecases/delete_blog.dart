import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteBlog implements UseCase<void, DeleteBlogParams> {
  final BlogRepository blogRepository;

  DeleteBlog(this.blogRepository);

  @override
  Future<Either<Failure, void>> call(DeleteBlogParams params) async {
    return await blogRepository.deleteBlogById(blogId: params.blogId);
  }
}

class DeleteBlogParams {
  final String blogId;

  DeleteBlogParams({required this.blogId});
}
