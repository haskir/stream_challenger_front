import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_challenge/feature/create_challenge/create_challenge.dart';
import 'package:stream_challenge/feature/streamer_challenges_widget/widgets/list_widget.dart';
import 'package:stream_challenge/main_widgets/body_widgets/challenges_list.dart';
import 'package:stream_challenge/main_widgets/body_widgets/profile.dart';

final GoRouter goRouter = GoRouter(
  initialLocation: '/',
  routes: routes,
);

List<GoRoute> routes = [
  GoRoute(
    path: '/',
    builder: (context, state) => Center(child: Text("Home page")),
  ),
  GoRoute(
    path: '/challenge_create',
    builder: (context, state) => const CreateChallengeWidget(),
  ),
  GoRoute(
    path: '/challenges',
    builder: (context, state) => const ChallengeListWidget(),
  ),
  GoRoute(
    path: '/profile',
    builder: (context, state) => const ProfileWidget(),
  ),
  GoRoute(
    path: '/panel',
    builder: (context, state) => PanelWidget(),
  ),
];
