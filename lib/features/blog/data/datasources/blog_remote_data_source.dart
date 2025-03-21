import 'dart:io';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  });
  Future<List<BlogModel>> getAllBlogs();
  Future<List<BlogModel>> getAllBlogsById({
    required String userId,
  });
  Future<void> deleteBlogById({
    required String blogId,
  });
  Future<BlogModel> editBlogById({required BlogModel blog});
  Future<String> updateBlogImage({
    required File image,
    required BlogModel blog,
  });
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;
  final Logger logger = Logger();

  BlogRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogData =
          await supabaseClient.from('blogs').insert(blog.toJson()).select();
      return BlogModel.fromJson(blogData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  }) async {
    try {
      await supabaseClient.storage.from('blog_images').upload(blog.id, image);

      return supabaseClient.storage.from('blog_images').getPublicUrl(blog.id);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> updateBlogImage({
    required File image,
    required BlogModel blog,
  }) async {
    try {
      await supabaseClient.storage
          .from('blog_images')
          .remove(['762c1b10-05ef-11f0-95c0-6f96c2c3a425']);

      logger.i("select");

      await supabaseClient.storage.from('blog_images').upload(blog.id, image);
      logger.i("select");

      return supabaseClient.storage.from('blog_images').getPublicUrl(blog.id);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      final blogs =
          await supabaseClient.from('blogs').select('*, users (name)');
      return blogs
          .map(
            (blog) => BlogModel.fromJson(blog).copyWith(
              userName: blog['users']['name'],
            ),
          )
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogsById({required String userId}) async {
    try {
      final blogData = await supabaseClient
          .from('blogs')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: true);

      return blogData
          .map(
            (blog) => BlogModel.fromJson(blog).copyWith(),
          )
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteBlogById({required String blogId}) async {
    try {
      await supabaseClient.from('blogs').delete().eq('id', blogId);
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  @override
  Future<BlogModel> editBlogById({required BlogModel blog}) async {
    try {
      final blogData = await supabaseClient
          .from('blogs')
          .update(blog.toJson())
          .eq('id', blog.id);
      return blogData;
    } catch (error) {
      throw ServerException(error.toString());
    }
  }
}
