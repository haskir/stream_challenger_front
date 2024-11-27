import 'package:flutter/material.dart';
import 'package:stream_challenge/data/models/challenge.dart';

class ChallengeView extends StatelessWidget {
  static const Map<String, Color> colors = {
    "PENDING": Colors.orange,
    "ACCEPTED": Colors.blue,
    "ENDED": Colors.blueAccent,
    "SUCCESSFUL": Colors.green,
    "FAILED": Colors.black,
    "REJECTED": Colors.red,
  };

  final Challenge challenge;
  const ChallengeView({
    super.key,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      challenge.toString(),
      style: TextStyle(color: ChallengeView.colors[challenge.status]),
    );
  }
}
