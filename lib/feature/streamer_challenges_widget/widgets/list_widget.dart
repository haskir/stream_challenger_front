import 'package:flutter/material.dart';
import 'package:stream_challenge/data/models/challenge.dart';

import 'challenge_widget.dart';

// ignore: must_be_immutable
class PanelWidget extends StatelessWidget {
  List<Challenge> challenges = [
    Challenge.testPending(),
    Challenge.testPending(),
    Challenge.testAccepted(),
    Challenge.testRejected(),
    Challenge.testRejected(),
    Challenge.testReported(),
  ];

  PanelWidget({
    super.key,
    // required this.challenges,
  });

  void _acceptChallenge(Challenge challenge) {
    // Обработка принятия челленджа
  }

  void _rejectChallenge(Challenge challenge) {
    // Обработка отклонения челленджа
  }

  void _reportChallenge(Challenge challenge) {
    // Обработка жалобы на челлендж
  }

  void _endChallenge(Challenge challenge) {
    // Обработка завершения испытания
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        final challenge = challenges[index];
        return ChallengeWidget(
          challenge: challenge,
          onAccept: () => _acceptChallenge(challenge),
          onReject: () => _rejectChallenge(challenge),
          onReport: () => _reportChallenge(challenge),
          onEnd: () => _endChallenge(challenge),
        );
      },
    );
  }
}
