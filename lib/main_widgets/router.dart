import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_challenge/feature/create_challenge/create_challenge_widget.dart';
import 'package:stream_challenge/feature/single_challenge_view/widgets/single_challenge_widget.dart';
import 'package:stream_challenge/feature/streamer_panel/panel_widget.dart';
import 'package:stream_challenge/feature/profile/profile.dart';

import '../../main_widgets/body_widgets/home_page.dart';

final GoRouter goRouter = GoRouter(
  initialLocation: '/',
  routes: routes,
);

List<GoRoute> routes = [
  GoRoute(
    path: '/',
    builder: (context, state) => HomePage(),
  ),
  GoRoute(
      path: '/challenge/:performerLogin',
      builder: (context, state) {
        return CreateChallengeWidget(
          performerLogin: state.pathParameters['performerLogin'] ?? '',
        );
      }),
  GoRoute(
    path: '/panel',
    builder: (context, state) => PanelWidget(),
  ),
  GoRoute(
    path: '/challenges/:id',
    builder: (context, state) {
      final String? pathId = state.pathParameters['id'];
      try {
        return ViewChallengeWidget(id: int.parse(pathId!));
      } catch (e) {
        return const Text('Invalid id');
      }
    },
  ),
  GoRoute(
    path: '/profile',
    builder: (context, state) => ProfilePage(),
  ),
];
