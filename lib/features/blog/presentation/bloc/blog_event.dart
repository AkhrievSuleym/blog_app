part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

final class BlogUploadEvent extends BlogEvent {
  final String userId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;

  BlogUploadEvent({
    required this.userId,
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
  });
}

final class GetAllBlogsEvent extends BlogEvent {}

final class GetAllBlogsByIdEvent extends BlogEvent {
  final String userId;

  GetAllBlogsByIdEvent({required this.userId});
}

final class BlogDeleteEvent extends BlogEvent {
  final String blogId;

  BlogDeleteEvent({required this.blogId});
}
