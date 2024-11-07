// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/core/platform/auth.dart';
import 'package:stream_challenge/feature/presentation/widgets/auth_widget.dart';
import 'package:stream_challenge/feature/presentation/widgets/body_widgets/challenge_create.dart';
import 'package:stream_challenge/feature/presentation/widgets/body_widgets/challenges_list.dart';
import 'package:stream_challenge/feature/presentation/widgets/logo.dart';
import 'package:stream_challenge/feature/presentation/widgets/body_widgets/profile.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({super.key, required this.onLocaleChange});

  final dynamic onLocaleChange;

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (RouteSettings settings) {
          Widget page;
          switch (settings.name) {
            case '/challenge_create':
              page = const ChallengeCreateWidget();
              break;
            case '/challenges':
              page = const ChallengeListWidget();
              break;
            case '/profile':
              page = const ProfileWidget();
              break;
            default:
              page = const LogoWidget();
          }
          return MaterialPageRoute(builder: (_) => page, settings: settings);
        },
      ),
    );
  }

  void navigateTo(String routeName) {
    _navigatorKey.currentState?.pushNamed(routeName);
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? username;
  final String? avatarUrl;

  const CustomAppBar({super.key, this.username, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const LogoWidget(),
          const TabsRow(),
          AuthWidget(auth: Auth()),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class TabsRow extends StatelessWidget {
  const TabsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final mainWidgetState = context.findAncestorStateOfType<_MainWidgetState>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: () => mainWidgetState?.navigateTo('/challenge_create'),
          child:
              Text(AppLocalizations.of(context).translate('CreateChallenge')),
        ),
        TextButton(
          onPressed: () => mainWidgetState?.navigateTo('/challenges'),
          child: Text(AppLocalizations.of(context).translate('Challenges')),
        ),
        TextButton(
          onPressed: () => mainWidgetState?.navigateTo('/profile'),
          child: Text(AppLocalizations.of(context).translate('Profile')),
        ),
      ],
    );
  }
}
