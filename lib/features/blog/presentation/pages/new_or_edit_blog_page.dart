import 'dart:io';

import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/cubits/update_user/update_user_cubit.dart';
import 'package:blog_app/core/common/entities/blog_entity.dart';
import 'package:blog_app/core/common/widgets/loading.dart';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/file_from_image_url.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewOrEditBlogPage extends StatefulWidget {
  static route([BlogEntity? blog]) =>
      MaterialPageRoute(builder: (context) => NewOrEditBlogPage(blog: blog));

  final BlogEntity? blog;

  const NewOrEditBlogPage({super.key, this.blog});

  @override
  State<NewOrEditBlogPage> createState() => _NewOrEditBlogPageState();
}

class _NewOrEditBlogPageState extends State<NewOrEditBlogPage> {
  late final TextEditingController titleController;
  late final TextEditingController contentController;
  late final String userName;
  final formKey = GlobalKey<FormState>();
  List<String> selectedTopics = [];
  File? image, userImage;

  @override
  void initState() {
    super.initState();
    if (widget.blog != null) {
      titleController = TextEditingController(text: widget.blog!.title);
      contentController = TextEditingController(text: widget.blog!.content);
      selectedTopics = widget.blog!.topics;
      userName = widget.blog!.userName ?? '';
      fileFromImageUrl(widget.blog!.imageUrl)?.then((file) {
        setState(() {
          image = file;
        });
      });
    } else {
      titleController = TextEditingController();
      contentController = TextEditingController();
    }
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void saveBlog() {
    if (formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        image != null) {
      final user = (context.read<AppUserCubit>().state as AppUserLoggedIn).user;
      fileFromImageUrl(user.imageUrl)?.then((file) {
        setState(() {
          userImage = file;
        });
      });

      if (widget.blog == null) {
        context.read<UpdateUserCubit>().updateUserProfile(
              image: userImage,
              name: user.name,
              email: user.email,
              id: user.id,
              blogsCount: user.blogsCount + 1,
            );
        context.read<BlogBloc>().add(
              BlogUploadEvent(
                userId: user.id,
                title: titleController.text.trim(),
                content: contentController.text.trim(),
                image: image,
                topics: selectedTopics,
              ),
            );
      } else {
        context.read<BlogBloc>().add(BlogUpdateEvent(
            userId: user.id,
            blogId: widget.blog!.id,
            title: titleController.text.trim(),
            content: contentController.text.trim(),
            image: image!,
            topics: selectedTopics,
            username: userName));
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                saveBlog();
              },
              icon: const Icon(Icons.done_rounded))
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error, isError: true);
          } else if (state is BlogUploadSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              BlogPage.route(),
              (route) => false,
            );
          } else if (state is BlogUpdateSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              BlogViewerPage.route(state.blog),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loading();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
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
                                ),
                              ),
                            ),
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
                        children: Constants.topics
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
        },
      ),
    );
  }
}
