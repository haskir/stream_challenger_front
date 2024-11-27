import 'package:flutter/material.dart';
import 'package:stream_challenge/data/models/challenge.dart';

class ChallengeView extends StatelessWidget {
  final Challenge challenge;
  const ChallengeView({
    super.key,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      challenge.toString(),
    );
  }
}
