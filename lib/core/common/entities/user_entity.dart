// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserEntity {
  final String id;
  final String email;
  final String name;
  final String imageUrl;
  final int blogsCount;

  UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.imageUrl,
    required this.blogsCount,
  });
}
