import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/feature/single_challenge_view/challenge_provider.dart';

class ViewChallengeWidget extends ConsumerStatefulWidget {
  final int id;
  const ViewChallengeWidget({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<ViewChallengeWidget> createState() => _ChallengeView();
}

class _ChallengeView extends ConsumerState<ViewChallengeWidget> {
  @override
  Widget build(BuildContext context) {
    final challengeAsyncValue = ref.watch(challengeProvider(widget.id));
    return challengeAsyncValue.when(
      data: (challenge) {
        if (challenge == null) {
          return const Center(child: Text('404 - Challenge not found'));
        }
        return Center(
            child: Container(
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(16),
          child: Text(
            challenge.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ));
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (err, stack) => Center(
        child: Text('Error: $err'),
      ),
    );
  }
}
