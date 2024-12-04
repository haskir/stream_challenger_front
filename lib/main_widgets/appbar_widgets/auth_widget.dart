import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_challenge/common/text_consts.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/providers/providers.dart';

class AuthWidget extends ConsumerWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    if (authState.isAuthenticated) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => context.go('/profile'),
              icon: CircleAvatar(
                radius: 20,
                backgroundImage:
                    NetworkImage(authState.user!.profile_image_url),
              ),
            ),
            const SizedBox(width: 5),
            IconButton(
              onPressed: () async {
                context.go('/');
                await ref.read(authStateProvider.notifier).logout();
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
      );
    }
    return Center(
      child: Row(
        children: [
          TextButton(
            child: Text(AppLocale.of(context).translate(mAuth)),
            onPressed: () async {
              await ref.read(authStateProvider.notifier).auth(context);
            },
          ),
        ],
      ),
    );
  }
}
