import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SingleChallengeWidget extends ConsumerWidget {
  const SingleChallengeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //challenge = ref.watch(singleChallengeProvider);
    return const Text('SingleChallengeWidget');
  }
}
