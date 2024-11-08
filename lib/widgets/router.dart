import 'package:go_router/go_router.dart';
import 'package:stream_challenge/feature/streamer_challenges_widget/pages/list_widget.dart';
import 'package:stream_challenge/widgets/body_widgets/challenge_create.dart';
import 'package:stream_challenge/widgets/body_widgets/challenges_list.dart';
import 'package:stream_challenge/widgets/body_widgets/profile.dart';
import 'package:stream_challenge/widgets/appbar_widgets/logo.dart';

final GoRouter goRouter = GoRouter(
  initialLocation: '/',
  routes: routes,
);

List<GoRoute> routes = [
  GoRoute(
    path: '/',
    builder: (context, state) => LogoWidget(
      onTap: () => context.go('/'),
    ),
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
  GoRoute(
    path: '/panel',
    builder: (context, state) => const PanelWidget(),
  ),
];
