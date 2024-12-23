import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/core/platform/firebase.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FirebaseService firebaseService = ref.watch(firebaseProvider);
    return Center(
      child: TextButton.icon(
        onPressed: () async {
          await firebaseService.requestPermission();
        },
        icon: Icon(Icons.notifications_on),
        label: Text("Request permissions"),
      ),
    );
  }
}
