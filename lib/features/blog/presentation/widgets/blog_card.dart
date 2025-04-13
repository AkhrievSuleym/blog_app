import 'dart:io';

import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/entities/blog_entity.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/capitalize.dart';
import 'package:blog_app/core/utils/file_from_image_url.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogCard extends StatelessWidget {
  final BlogEntity blog;
  final Color? color;
  const BlogCard({
    super.key,
    required this.blog,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final userImageUrl =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.imageUrl;

    return GestureDetector(
      onTap: () {
        Navigator.push(context, BlogViewerPage.route(blog));
      },
      child: Container(
        height: 540,
        padding: const EdgeInsets.only(bottom: 5),
        margin: const EdgeInsets.all(16).copyWith(bottom: 4),
        decoration: BoxDecoration(
          color: AppPallete.backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[300],
                      child: userImageUrl != ''
                          ? Image.network(
                              userImageUrl,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.person,
                              color: color,
                            )),
                  const SizedBox(width: 12),
                  Text(
                    blog.userName?.capitalize() ?? 'Unknown',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'BigShouldersStencil',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.white,
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Text(
                  blog.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'BigShouldersStencil',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Center(
              child: Container(
                child: blog.imageUrl != ''
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Image.network(
                          blog.imageUrl,
                          fit: BoxFit.cover,
                          height: 350,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.image, size: 50),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
