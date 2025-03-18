import 'package:blog_app/core/common/entities/user_entity.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
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
  void _signOut() {
    context.read<AuthBloc>().add(UserLoggedOutEvent());
  }

  @override
  Widget build(BuildContext context) {
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
            icon: const Icon(Icons.arrow_back_ios),
          ),
          actions: [
            IconButton(
              onPressed: () {
                _signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  LoginPage.route(),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout_outlined),
            )
          ]),
      body: Column(children: [
        Text(widget.user.name),
        Text(widget.user.email),
      ]),
    );
  }
}
