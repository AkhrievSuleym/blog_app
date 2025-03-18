import 'package:blog_app/core/common/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel(
      {required super.id,
      required super.email,
      required super.name,
      required super.imageUrl});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'image_url': imageUrl,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['image_url'] as String,
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? imageUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
