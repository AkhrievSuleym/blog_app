import 'package:blog_app/core/common/entities/blog_entity.dart';
import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/core/utils/capitalize.dart';

import 'package:blog_app/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:flutter/material.dart';

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
    return GestureDetector(
      onTap: () {
        Navigator.push(context, BlogViewerPage.route(blog));
      },
      child: Container(
        height: 200,
        margin: const EdgeInsets.all(16).copyWith(
          bottom: 4,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: blog.topics
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Chip(
                                label: Text(
                                  e,
                                  style: const TextStyle(
                                      color: Color.fromRGBO(
                                          0x82, 0x37, 0x2b, 1.0)),
                                ),
                                color: WidgetStateProperty.all(Colors.white),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Text(
                    blog.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'BigShouldersStencil',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                'Published by: ${blog.userName?.capitalize()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'BigShouldersStencil',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${calculateReadingTime(blog.content)} min',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
