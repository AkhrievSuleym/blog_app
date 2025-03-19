import 'dart:io';

import 'package:blog_app/core/common/entities/user_entity.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/capitalize.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  static route(UserEntity user) => MaterialPageRoute(
        builder: (context) => ProfilePage(user: user),
      );
  final UserEntity user;

  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void _signOut() {
    context.read<AuthBloc>().add(UserLoggedOutEvent());
  }

  void _updateUserProfile(File image, String name, String email, String id) {
    context.read<AuthBloc>().add(UserUpdateEvent(
          image: image,
          name: name,
          email: email,
          id: id,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Profile',
            style: profileTextStyle(fontSize: 30),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                BlogPage.route(),
                (route) => false,
              );
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          actions: [
            PopupMenuButton(
              icon: const Icon(Icons.menu),
              color: AppPallete.backgroundColor,
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Row(
                    children: [
                      Text(
                        'Settings',
                        style: profileTextStyle(),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(Icons.settings)
                    ],
                  ),
                  onTap: () {
                    // Handle option 1 selection
                  },
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Text(
                        'Help & Support',
                        style: profileTextStyle(),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(Icons.mail)
                    ],
                  ),
                  onTap: () {
                    // Handle option 2 selection
                  },
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Text(
                        'Sign Out',
                        style: profileTextStyle(),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(Icons.logout_outlined)
                    ],
                  ),
                  onTap: () {
                    _signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      LoginPage.route(),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ]),
      body: Center(
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          image != null
              ? GestureDetector(
                  onTap: selectImage,
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
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
                    radius: const Radius.circular(100),
                    borderType: BorderType.Circle,
                    strokeCap: StrokeCap.round,
                    child: const SizedBox(
                      height: 150,
                      width: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            size: 40,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Your image',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
          Text(
            widget.user.name.capitalize(),
            style: profileTextStyle(fontSize: 50),
          ),
          Text(
            widget.user.email,
            style: profileTextStyle(),
          ),
        ]),
      ),
    );
  }
}

TextStyle profileTextStyle({double fontSize = 20}) {
  return TextStyle(
    fontFamily: 'BigShouldersStencil',
    fontSize: fontSize,
    fontWeight: FontWeight.bold,
  );
}
