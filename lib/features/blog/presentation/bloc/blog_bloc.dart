import 'dart:io';

import 'package:blog_app/core/common/entities/blog_entity.dart';
import 'package:blog_app/core/common/entities/user_entity.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/features/blog/domain/usecases/delete_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs_by_id.dart';
import 'package:blog_app/features/blog/domain/usecases/update_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  final GetAllBlogsById _getAllBlogsById;
  final DeleteBlog _deleteBlog;
  final UpdateBlog _updateBlog;

  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogsById getAllBlogsById,
    required GetAllBlogs getAllBlogs,
    required DeleteBlog deleteBlog,
    required UpdateBlog updateBlog,
  })  : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        _getAllBlogsById = getAllBlogsById,
        _deleteBlog = deleteBlog,
        _updateBlog = updateBlog,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) {
      emit(BlogLoading());
    });
    on<BlogUploadEvent>(_onBlogUpload);
    on<GetAllBlogsEvent>(_onGetAllBlogs);
    on<GetAllBlogsByIdEvent>(_onGetAllBlogsById);
    on<BlogDeleteEvent>(_onDeleteBlog);
    on<BlogUpdateEvent>(_onBlogUpdate);
  }

  void _onBlogUpload(BlogUploadEvent event, Emitter<BlogState> emit) async {
    final res = await _uploadBlog(
      UploadBlogParams(
          userId: event.userId,
          title: event.title,
          content: event.content,
          image: event.image,
          topics: event.topics),
    );

    res.fold(
      (failure) => emit(BlogFailure(failure.message)),
      (blog) => emit(BlogUploadSuccess()),
    );
  }

  void _onGetAllBlogs(GetAllBlogsEvent event, Emitter<BlogState> emit) async {
    final res = await _getAllBlogs(EmptyParams());

    res.fold(
      (failure) => emit(BlogFailure(failure.message)),
      (blogs) => emit(BlogDisplaySuccess(blogs)),
    );
  }

  void _onGetAllBlogsById(
      GetAllBlogsByIdEvent event, Emitter<BlogState> emit) async {
    final res =
        await _getAllBlogsById(GetAllBlogsByIdParams(userId: event.userId));

    res.fold(
      (failure) => emit(BlogFailure(failure.message)),
      (blogs) => emit(BlogsByIdDisplaySuccess(blogs)),
    );
  }

  void _onDeleteBlog(BlogDeleteEvent event, Emitter<BlogState> emit) async {
    final res = await _deleteBlog(
      DeleteBlogParams(blogId: event.blogId),
    );

    res.fold(
      (failure) => emit(BlogFailure(failure.message)),
      (blog) => emit(BlogDeleteSuccess()),
    );
  }

  void _onBlogUpdate(BlogUpdateEvent event, Emitter<BlogState> emit) async {
    final res = await _updateBlog(
      UpdateBlogParams(
        blogId: event.blogId,
        userId: event.userId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
        userName: event.username,
      ),
    );

    res.fold(
      (failure) => emit(BlogFailure(failure.message)),
      (blog) => emit(BlogUpdateSuccess(blog)),
    );
  }
}
