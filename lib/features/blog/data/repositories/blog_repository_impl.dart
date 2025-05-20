import 'dart:io';

import 'package:blog_app/core/common/entities/blog_entity.dart';
import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/network/connection.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  //final BlogLocalDataSource blogLocalDataSource;
  final ConnectionChecker connectionChecker;
  final Logger _logger;

  BlogRepositoryImpl(
    this.blogRemoteDataSource,
    //this.blogLocalDataSource,
    this.connectionChecker,
    this._logger,
  );

  @override
  Future<Either<Failure, BlogEntity>> uploadBlog({
    required File? image,
    required String title,
    required String content,
    required String userId,
    required List<String> topics,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        userId: userId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );

      late final String imageUrl;
      if (image != null) {
        imageUrl = await blogRemoteDataSource.uploadBlogImage(
            image: image, blog: blogModel);
      } else {
        imageUrl = '';
      }

      blogModel = blogModel.copyWith(
        imageUrl: imageUrl,
      );

      final uploadBlog = await blogRemoteDataSource.uploadBlog(blogModel);

      return right(uploadBlog);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<BlogEntity>>> getAllBlogs() async {
    try {
      // if (!await connectionChecker.isConnected) {
      //   final blogs = blogLocalDataSource.loadBlogs();
      //   return right(blogs);
      // }
      final blogs = await blogRemoteDataSource.getAllBlogs();
      //blogLocalDataSource.uploadLocalBlogs(blogs: blogs);
      return right(blogs);
    } on ServerException catch (e) {
      return left(
        Failure(e.message),
      );
    }
  }

  @override
  Future<Either<Failure, List<BlogEntity>>> getAllBlogsById(
      {required String userId}) async {
    try {
      final blogs = await blogRemoteDataSource.getAllBlogsById(userId: userId);
      return right(blogs);
    } on ServerException catch (e) {
      _logger.i(e.message);
      return left(
        Failure(e.message),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteBlogById({required String blogId}) async {
    try {
      await blogRemoteDataSource.deleteBlogById(blogId: blogId);
      return right(null);
    } on ServerException catch (e) {
      return left(
        Failure(e.message),
      );
    }
  }

  @override
  Future<Either<Failure, BlogModel>> editBlogById(
      {required String blogId,
      required String userId,
      required String userName,
      required File image,
      required String title,
      required String content,
      required List<String> topics}) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }
      BlogModel blogModel = BlogModel(
        id: blogId,
        userId: userId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
        userName: userName,
      );

      final imageUrl = await blogRemoteDataSource.updateBlogImage(
          image: image, blog: blogModel);

      blogModel = blogModel.copyWith(
        imageUrl: imageUrl,
      );

      final updateBlog =
          await blogRemoteDataSource.editBlogById(blog: blogModel);

      return right(updateBlog);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
