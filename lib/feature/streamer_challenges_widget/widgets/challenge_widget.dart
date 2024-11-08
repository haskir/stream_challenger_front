import 'package:flutter/material.dart';
import 'package:stream_challenge/data/models/challenge.dart';

import 'action_buttons.dart';

class ChallengeWidget extends StatelessWidget {
  final Challenge challenge;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onReport;
  final VoidCallback onEnd;

  const ChallengeWidget({
    super.key,
    required this.challenge,
    required this.onAccept,
    required this.onReject,
    required this.onReport,
    required this.onEnd,
  });

  Text getStatusText(Challenge challenge) {
    switch (challenge.status) {
      case "COMPLETED":
        return const Text("Status: Completed",
            style: TextStyle(color: Colors.green));
      case "REJECTED":
        return const Text("Status: Rejected",
            style: TextStyle(color: Colors.red));
      case "ACCEPTED":
        return const Text("Status: In Progress",
            style: TextStyle(color: Colors.blue));
      default:
        return const Text("Status: Hidden",
            style: TextStyle(color: Colors.grey));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              challenge.description,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ChallengeInfoWidget(challenge: challenge),
            const SizedBox(height: 8),
            if (challenge.status == "PENDING") ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:
                    getActionButtons(context, onAccept, onReject, onReport),
              ),
            ] else if (challenge.status == "ACCEPTED") ...[
              Center(child: endChallengeButton(onEnd)),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: getStatusText(challenge),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: getAuthorInfo(challenge.author),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
