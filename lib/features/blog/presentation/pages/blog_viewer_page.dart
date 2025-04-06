import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/entities/blog_entity.dart';
import 'package:blog_app/core/common/entities/user_entity.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/core/utils/format_date.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/features/blog/presentation/pages/new_or_edit_blog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogViewerPage extends StatefulWidget {
  static route(BlogEntity blog) => MaterialPageRoute(
        builder: (context) => BlogViewerPage(blog: blog),
      );

  final BlogEntity blog;

  const BlogViewerPage({
    super.key,
    required this.blog,
  });

  @override
  State<BlogViewerPage> createState() => _BlogViewerPageState();
}

class _BlogViewerPageState extends State<BlogViewerPage> {
  void _deleteBlog(String id) {
    context.read<BlogBloc>().add(BlogDeleteEvent(blogId: id));
  }

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AppUserCubit>().state as AppUserLoggedIn).user;
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  BlogPage.route(),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.arrow_back_ios_new_sharp))),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.blog.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'By ${widget.blog.userName}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${formatDateBydMMMYYYY(widget.blog.updatedAt)} . ${calculateReadingTime(widget.blog.content)} min',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppPallete.greyColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.blog.imageUrl,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.blog.content,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 2,
                  ),
                ),
                (user.id == widget.blog.userId)
                    ? Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(context,
                                  NewOrEditBlogPage.route(widget.blog));
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              _deleteBlog(widget.blog.id);
                              showSnackBar(context, 'Success delete');
                              Navigator.pushAndRemoveUntil(
                                context,
                                BlogPage.route(),
                                (route) => false,
                              );
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              showSnackBar(
                                  context, 'You can edit only your blogs!');
                            },
                            icon: const Icon(Icons.edit_off_outlined),
                          ),
                          IconButton(
                            onPressed: () {
                              showSnackBar(
                                  context, 'You can delete only your blogs!');
                            },
                            icon: const Icon(Icons.delete_forever_outlined),
                          ),
                        ],
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
