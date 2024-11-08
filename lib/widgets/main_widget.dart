import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/core/platform/auth.dart';
import 'appbar_widgets/auth_widget.dart';
import 'appbar_widgets/logo.dart';

class MainWidget extends StatelessWidget {
  final Widget child;
  final Function(String) onLocaleChange;

  const MainWidget(
      {super.key, required this.child, required this.onLocaleChange});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(onLocaleChange: onLocaleChange),
      body: child,
    );
  }
}

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(String) onLocaleChange;
  const CustomAppBar({super.key, required this.onLocaleChange});

  @override
  CustomAppBarState createState() => CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomAppBarState extends State<CustomAppBar> {
  String currentLanguage = 'en';

  void _changeLanguage(String newLanguage) {
    setState(() {
      currentLanguage = newLanguage;
      widget.onLocaleChange(newLanguage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // Левые элементы
      leading: LogoWidget(onTap: () => context.go('/')),
      // Центральные элементы
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () => context.go('/challenge_create'),
            child: Text(
                AppLocalizations.of(context).translate('Create Challenge')),
          ),
          TextButton(
            onPressed: () => context.go('/challenges'),
            child: Text(AppLocalizations.of(context).translate('Challenges')),
          ),
          TextButton(
            onPressed: () => context.go('/profile'),
            child: Text(AppLocalizations.of(context).translate('Profile')),
          ),
        ],
      ),

      // Правые элементы
      actions: [
        AuthWidget(auth: Auth()),
        PopupMenuButton<String>(
          icon: const Icon(Icons.language),
          itemBuilder: (context) {
            return [
              const PopupMenuItem(value: 'en', child: Text('English')),
              const PopupMenuItem(value: 'ru', child: Text('Русский')),
            ];
          },
          onSelected: _changeLanguage,
        ),
      ],
    );
  }
}
