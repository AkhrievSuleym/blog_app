import 'dart:io';

import 'package:blog_app/features/blog/domain/usecases/uploadBlog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog uploadblog;

  BlogBloc(this.uploadblog) : super(BlogInitial()) {
    on<BlogEvent>((event, emit) {
      emit(BlogLoading());
    });
    on<BlogUploadEvent>(_onBlogUpload);
  }

  void _onBlogUpload(BlogUploadEvent event, Emitter<BlogState> emit) async {
    final res = await uploadblog(UploadBlogParams(
        userId: event.userId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics));

    res.fold(
      (failure) => emit(BlogFailure(failure.message)),
      (blog) => emit(BlogSuccess()),
    );
  }
}
