import 'dart:io';

import 'package:blog_app/core/common/entities/blog_entity.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;

  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
  })  : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) {
      emit(BlogLoading());
    });
    on<BlogUploadEvent>(_onBlogUpload);
    on<GetAllBlogsEvent>(_onGetAllBlogs);
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
}
