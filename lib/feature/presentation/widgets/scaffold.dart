// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/core/platform/auth.dart';
import 'package:stream_challenge/feature/presentation/widgets/auth_widget.dart';
import 'package:stream_challenge/feature/presentation/widgets/logo.dart';

class MainWidget extends StatelessWidget {
  const MainWidget({super.key, required this.onLocaleChange});

  final dynamic onLocaleChange;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
          // onLocaleChange: onLocaleChange,
          ),
      body: null,
    );
  }
}

// class AuthState extends State {
//   @override
//   Widget build(BuildContext context) {
//     const CustomAppBar();
//   }
// }

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? username;
  final String? avatarUrl;
  // final dynamic onLocaleChange;

  const CustomAppBar(
      {super.key,
      // required this.onLocaleChange,
      this.username,
      this.avatarUrl}); // URL для аватарки пользователя

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Логотип с текстом слева
          const LogoWidget(),
          // Центральные кнопки
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {},
                child: Text(
                    AppLocalizations.of(context).translate('CreateChallenge'),
                    style: const TextStyle(color: Colors.black)),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                    AppLocalizations.of(context).translate('Challenges'),
                    style: const TextStyle(color: Colors.black)),
              ),
              TextButton(
                onPressed: () {},
                child: Text(AppLocalizations.of(context).translate('Profile'),
                    style: const TextStyle(color: Colors.black)),
              ),
            ],
          ),
          AuthWidget(auth: Auth()),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  // @override
  // AuthState createState() {
  //   return AuthState();
  // }
}
