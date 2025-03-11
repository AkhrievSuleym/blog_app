import 'dart:io';

import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class NewBlogPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const NewBlogPage());
  const NewBlogPage({super.key});

  @override
  State<NewBlogPage> createState() => _NewBlogPageState();
}

class _NewBlogPageState extends State<NewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  List<String> selectedTopics = [];
  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.done_rounded))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              image != null
                  ? GestureDetector(
                      onTap: selectImage,
                      child: SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                image!,
                                fit: BoxFit.cover,
                              ))),
                    )
                  : GestureDetector(
                      onTap: () => selectImage(),
                      child: DottedBorder(
                        color: AppPallete.borderColor,
                        dashPattern: const [10, 4],
                        radius: const Radius.circular(10),
                        borderType: BorderType.RRect,
                        strokeCap: StrokeCap.round,
                        child: const SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.folder_open_outlined,
                                size: 40,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text('Select your image',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    'Technology',
                    'Business',
                    'Sport',
                    'Programming',
                    'Entertainment',
                    'Games',
                  ]
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.all(5),
                          child: GestureDetector(
                            onTap: () {
                              if (selectedTopics.contains(e)) {
                                selectedTopics.remove(e);
                              } else {
                                selectedTopics.add(e);
                              }
                              setState(() {});
                            },
                            child: Chip(
                              label: Text(e),
                              color: selectedTopics.contains(e)
                                  ? const WidgetStatePropertyAll(
                                      AppPallete.gradient1,
                                    )
                                  : null,
                              side: selectedTopics.contains(e)
                                  ? null
                                  : const BorderSide(
                                      color: AppPallete.borderColor,
                                    ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              BlogEditor(
                controller: titleController,
                hintText: 'Blog title',
              ),
              const SizedBox(
                height: 10,
              ),
              BlogEditor(
                controller: contentController,
                hintText: 'Blog content',
              )
            ],
          ),
        ),
      ),
    );
  }
}
