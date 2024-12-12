import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_challenge/core/platform/dio.dart';
import '../core/platform/auth_client.dart';
import '../data/models/auth_state.dart';
import '../main_widgets/main_widget.dart';
import '../main_widgets/router.dart';

final authStateProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());
final httpClientProvider = FutureProvider.autoDispose<Requester>((ref) async {
  final token = await ref.watch(authStateProvider.notifier).getTokenAsync();
  return Requester(token);
});

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainWidget(child: child);
        },
        routes: routes,
      ),
    ],
  );
});
