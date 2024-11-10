import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/providers.dart';

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
            GestureDetector(
              onTap: () => context.go('/profile'),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(authState.user!.profileImageUrl),
              ),
            ),
            const SizedBox(width: 15),
            GestureDetector(
              onTap: () async {
                await ref.read(authStateProvider.notifier).logout();
              },
              child: const Icon(Icons.logout),
            ),
          ],
        ),
      );
    }

    return Center(
      child: TextButton(
        child: Text(AppLocalizations.of(context).translate('Auth')),
        onPressed: () async {
          // Вызов метода входа через провайдер
          await ref.read(authStateProvider.notifier).auth(context);
        },
      ),
    );
  }
}
