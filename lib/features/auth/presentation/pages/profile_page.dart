import 'dart:io';

import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/cubits/update_user/update_user_cubit.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/capitalize.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:blog_app/features/auth/presentation/widgets/gradient_button.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      );

  const ProfilePage({
    super.key,
  });

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

  void _updateUserProfile(
      File? image, String name, String email, String id, int blogsCount) {
    context.read<UpdateUserCubit>().updateUserProfile(
          image: image,
          name: name,
          email: email,
          id: id,
          blogsCount: blogsCount,
        );
  }

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AppUserCubit>().state as AppUserLoggedIn).user;

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
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 36,
          ),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.menu,
              size: 36,
            ),
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
                onTap: () {},
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
                onTap: () {},
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Text(
                      'Messages',
                      style: profileTextStyle(),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(Icons.message_rounded)
                  ],
                ),
                onTap: () {},
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
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                image != null
                    ? GestureDetector(
                        onTap: selectImage,
                        child: SizedBox(
                          height: 140,
                          width: 140,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(90),
                            child: Image.file(
                              image!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : user.imageUrl != ''
                        ? GestureDetector(
                            onTap: selectImage,
                            child: SizedBox(
                              height: 250,
                              width: 550,
                              child: Image.network(
                                user.imageUrl,
                                fit: BoxFit.cover,
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
                  "Name: ${user.name.capitalize()}",
                  style: profileTextStyle(fontSize: 50),
                ),
                Text(
                  "Email: ${user.email}",
                  style: profileTextStyle(),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Amount of blogs: ${user.blogsCount.toString()}",
                  style: profileTextStyle(),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GradientButton(
                buttonWidth: 100,
                buttonHeight: 50,
                firstGradientColor: const Color.fromARGB(255, 72, 72, 75),
                secondGradientColor: const Color.fromARGB(255, 190, 194, 196),
                buttonText: 'save',
                onPressed: () async {
                  _updateUserProfile(
                    image,
                    user.name,
                    user.email,
                    user.id,
                    user.blogsCount,
                  );
                },
              ),
            ),
          ),
        ],
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
