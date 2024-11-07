// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/core/platform/auth.dart';
import 'package:stream_challenge/feature/presentation/widgets/auth_widget.dart';
import 'package:stream_challenge/feature/presentation/widgets/logo.dart';

import 'body_widgets/challenge_create.dart';
import 'body_widgets/challenges_list.dart';
import 'body_widgets/profile.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({super.key, required this.onLocaleChange});

  final dynamic onLocaleChange;

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  CustomAppBar appBar = const CustomAppBar();

  final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LogoWidget(),
      ),
      GoRoute(
        path: '/challenge_create',
        builder: (context, state) => const ChallengeCreateWidget(),
      ),
      GoRoute(
        path: '/challenges',
        builder: (context, state) => const ChallengeListWidget(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileWidget(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: MaterialApp.router(
        routerDelegate: _router.routerDelegate,
        routeInformationParser: _router.routeInformationParser,
        routeInformationProvider: _router.routeInformationProvider,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          // onPressed: () => Navigator.pushNamed(context, '/challenge_create'),
          onPressed: () => context.go('/challenge_create'),
          child:
              Text(AppLocalizations.of(context).translate('CreateChallenge')),
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
    );
  }
}
