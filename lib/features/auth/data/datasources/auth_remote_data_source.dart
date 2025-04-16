import 'dart:io';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    required int blogsCount,
  });

  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();
  Future<void> signOut();
  Future<String> uploadUserImage({
    required File image,
    required UserModel user,
  });
  Future<String> updateUserImage({
    required File image,
    required UserModel user,
  });
  Future<UserModel> updateProfile(UserModel user);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  final Logger _logger;

  AuthRemoteDataSourceImpl(this.supabaseClient, this._logger);

  @override
  Future<UserModel> login(
      {required String email, required String password}) async {
    try {
      final response = await supabaseClient.auth
          .signInWithPassword(password: password, email: email);
      if (response.user == null) {
        throw ServerException("User is null");
      }
      return UserModel.fromJson(response.user!.toJson());
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    required int blogsCount,
  }) async {
    try {
      final response = await supabaseClient.auth
          .signUp(password: password, email: email, data: {
        'name': name,
        'blogs_count': blogsCount,
      });
      if (response.user == null) {
        throw ServerException("User is null");
      }
      return UserModel.fromJson(response.user!.toJson());
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from('users')
            .select()
            .eq('id', currentUserSession!.user.id);
        return UserModel.fromJson(userData.first).copyWith(
          email: currentUserSession!.user.email,
        );
      }
      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
      _logger.i('success logged out');
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadUserImage({
    required File image,
    required UserModel user,
  }) async {
    try {
      try {
        await supabaseClient.storage.from('user_images').upload(user.id, image);
      } catch (e) {
        _logger.i(e.toString());

        throw ServerException(e.toString());
      }

      return supabaseClient.storage.from('user_images').getPublicUrl(user.id);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> updateUserImage({
    required File image,
    required UserModel user,
  }) async {
    try {
      await supabaseClient.storage.from('user_images').upload(
            user.id,
            image,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );
      final uniqueUrl =
          "${supabaseClient.storage.from('user_images').getPublicUrl(user.id)}?t=${DateTime.now().microsecondsSinceEpoch}";
      return uniqueUrl;
    } on StorageException catch (e) {
      _logger.e("Failed to update user image: ${e.message}");
      throw ServerException(e.message);
    } catch (e) {
      _logger.e("Unexpected error updating user image: $e");
      throw ServerException("Failed to update user image");
    }
  }

  @override
  Future<UserModel> updateProfile(
    UserModel user,
  ) async {
    try {
      final userData = await supabaseClient
          .from('users')
          .update(user.toJson())
          .eq('id', user.id)
          .select();

      return UserModel.fromJson(userData.first);
    } on PostgrestException catch (e) {
      _logger.i(e.message);
      throw ServerException(e.message);
    } catch (e) {
      _logger.i(e.toString());

      throw ServerException(e.toString());
    }
  }
}
