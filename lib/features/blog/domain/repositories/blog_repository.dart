import 'dart:io';

import 'package:blog_app/core/common/entities/blog_entity.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepository {
  Future<Either<Failure, BlogEntity>> uploadBlog({
    required File? image,
    required String title,
    required String content,
    required String userId,
    required List<String> topics,
  });
  Future<Either<Failure, List<BlogEntity>>> getAllBlogs();
  Future<Either<Failure, List<BlogEntity>>> getAllBlogsById({
    required String userId,
  });
  Future<Either<Failure, void>> deleteBlogById({
    required String blogId,
  });

  Future<Either<Failure, BlogModel>> editBlogById({
    required String blogId,
    required String userId,
    required String userName,
    required File image,
    required String title,
    required String content,
    required List<String> topics,
  });
}
