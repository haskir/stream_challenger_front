import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/providers.dart';

class ProfileWidget extends ConsumerWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).user;
    if (user == null) {
      return const Center(child: Text('No user'));
    }
    return Center(
      child: Text(
          " id: ${user.id}\n login: ${user.login}\n name: ${user.displayName}\n email: ${user.email}\n"),
    );
  }
}
