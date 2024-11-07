import 'package:go_router/go_router.dart';
import 'package:stream_challenge/feature/presentation/widgets/body_widgets/challenge_create.dart';
import 'package:stream_challenge/feature/presentation/widgets/body_widgets/challenges_list.dart';
import 'package:stream_challenge/feature/presentation/widgets/body_widgets/profile.dart';
import 'package:stream_challenge/feature/presentation/widgets/logo.dart';

// Определяем маршруты и страницы
final GoRouter router = GoRouter(
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
