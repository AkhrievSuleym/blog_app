import 'package:blog_app/core/common/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel(
      {required super.id,
      required super.email,
      required super.name,
      required super.imageUrl,
      required super.blogsCount});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'image_url': imageUrl,
      'blogs_count': blogsCount,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['image_url'] ?? '',
      blogsCount: map['blogs_count'] ?? 0,
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? imageUrl,
    int? blogsCount,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      blogsCount: blogsCount ?? this.blogsCount,
    );
  }
}
