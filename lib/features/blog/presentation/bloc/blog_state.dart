part of 'blog_bloc.dart';

@immutable
sealed class BlogState {}

final class BlogInitial extends BlogState {}

final class BlogLoading extends BlogState {}

final class BlogFailure extends BlogState {
  final String error;

  BlogFailure(this.error);
}

final class BlogUploadSuccess extends BlogState {}

final class BlogUpdateSuccess extends BlogState {
  final BlogEntity blog;

  BlogUpdateSuccess(this.blog);
}

final class BlogDeleteSuccess extends BlogState {}

final class BlogDisplaySuccess extends BlogState {
  final List<BlogEntity> blogs;

  BlogDisplaySuccess(this.blogs);
}

final class BlogsByIdDisplaySuccess extends BlogState {
  final List<BlogEntity> userBlogs;

  BlogsByIdDisplaySuccess(this.userBlogs);
}
