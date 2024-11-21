import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_challenge/feature/create_challenge/create_challenge.dart';
import 'package:stream_challenge/feature/single_challenge_view/widgets/single_challenge_widget.dart';
import 'package:stream_challenge/feature/streamer_panel/widgets/list_widget.dart';
import 'package:stream_challenge/main_widgets/body_widgets/balance_slider.dart';
import 'package:stream_challenge/main_widgets/body_widgets/challenges_list.dart';
import 'package:stream_challenge/feature/profile/profile.dart';

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
    builder: (context, state) => const ConfirmationDialogExample(),
  ),
  GoRoute(
    path: '/balance_slider',
    builder: (context, state) => BalanceSlider(
      balance: 10000.0,
      minPercentage: 10,
    ),
  ),
  GoRoute(
    path: '/profile',
    builder: (context, state) => ProfilePage(),
    /* routes: [
      GoRoute(
        path: 'transactions',
        builder: (context, state) => ProfilePage(path: "/transactions"),
      ),
      GoRoute(
        path: 'my-challenges',
        builder: (context, state) => ProfilePage(path: "/my-challenges"),
      ),
    ], */
  ),
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
  )
];
