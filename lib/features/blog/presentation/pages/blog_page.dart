import 'package:blog_app/features/blog/presentation/pages/new_blog_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blog App"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, NewBlogPage.route());
              },
              icon: const Icon(CupertinoIcons.add_circled))
        ],
      ),
    );
  }
}
