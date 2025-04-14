import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/loading.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/auth/presentation/pages/profile_page.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/new_or_edit_blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const BlogPage(),
      );
  const BlogPage({
    super.key,
  });

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(GetAllBlogsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blog App"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.person_sharp),
          onPressed: () {
            final user =
                (context.read<AppUserCubit>().state as AppUserLoggedIn).user;

            Navigator.pushReplacement(
              context,
              ProfilePage.route(user),
            );

            // context.read<BlogBloc>().add(GetAllBlogsByIdEvent(userId: user.id));

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => BlocListener<BlogBloc, BlogState>(
            //       listener: (context, state) {
            //         if (state is BlogsByIdDisplaySuccess) {
            //           Navigator.pushReplacement(
            //             context,
            //             ProfilePage.route(user),
            //           );
            //         } else if (state is BlogFailure) {
            //           showSnackBar(context, state.error, isError: true);
            //         }
            //       },
            //       child: const Scaffold(
            //         body: Loading(),
            //       ),
            //     ),
            //   ),
            // );
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, NewOrEditBlogPage.route());
              },
              icon: const Icon(CupertinoIcons.add_circled))
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error, isError: true);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loading();
          } else if (state is BlogDisplaySuccess) {
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                final blog = state.blogs[index];
                return BlogCard(
                  blog: blog,
                  color: index % 3 == 0
                      ? Colors.red[400]
                      : index % 2 == 0
                          ? Colors.green[400]
                          : Colors.cyan,
                );
              },
            );
          }
          return const SizedBox(
            height: 15,
          );
        },
      ),
    );
  }
}
