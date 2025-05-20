import 'dart:io';

import 'package:blog_app/core/common/entities/blog_entity.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateBlog implements UseCase<BlogEntity, UpdateBlogParams> {
  final BlogRepository blogRepository;

  UpdateBlog(this.blogRepository);

  @override
  Future<Either<Failure, BlogEntity>> call(UpdateBlogParams params) async {
    return await blogRepository.editBlogById(
      image: params.image,
      title: params.title,
      content: params.content,
      userId: params.userId,
      topics: params.topics,
      blogId: params.blogId,
      userName: params.userName,
    );
  }
}

class UpdateBlogParams {
  final String blogId;
  final String userId;
  final String userName;
  final String title;
  final String content;
  final File image;
  final List<String> topics;

  UpdateBlogParams({
    required this.blogId,
    required this.userId,
    required this.userName,
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
  });
}
