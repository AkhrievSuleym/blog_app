import 'dart:io';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/network/connection.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/core/common/entities/user_entity.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  AuthRepositoryImpl(this.remoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, UserEntity>> login(
      {required String email, required String password}) async {
    return _getUser(
      () async =>
          await remoteDataSource.login(email: email, password: password),
    );
  }

  @override
  Future<Either<Failure, UserEntity>> signUp(
      {required String name,
      required String email,
      required int blogsCount,
      required String password}) async {
    return _getUser(
      () async => await remoteDataSource.signUp(
          name: name, email: email, password: password, blogsCount: blogsCount),
    );
  }

  Future<Either<Failure, UserEntity>> _getUser(
      Future<UserEntity> Function() fn) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }
      final user = await fn();
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> currentUser() async {
    try {
      if (!await connectionChecker.isConnected) {
        final session = remoteDataSource.currentUserSession;

        if (session == null) {
          return left(
            Failure('User is not logged in!'),
          );
        }

        return right(
          UserModel(
            id: session.user.id,
            email: session.user.email ?? '',
            name: '',
            imageUrl: '',
            blogsCount: 0,
          ),
        );
      }
      final user = await remoteDataSource.getCurrentUserData();

      if (user == null) {
        return left(
          Failure('User is not logged in!'),
        );
      }

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }
      remoteDataSource.signOut();
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    required File? image,
    required String name,
    required String email,
    required String id,
    required int blogsCount,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }
      UserModel user = UserModel(
        name: name,
        email: email,
        imageUrl: '',
        id: id,
        blogsCount: blogsCount,
      );
      late final String imageUrl;
      if (image != null) {
        imageUrl =
            await remoteDataSource.updateUserImage(image: image, user: user);
      } else {
        imageUrl = '';
      }

      user = user.copyWith(
        imageUrl: imageUrl,
        email: email,
        blogsCount: blogsCount,
      );

      final updateUser = await remoteDataSource.updateProfile(user);

      return right(updateUser);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
