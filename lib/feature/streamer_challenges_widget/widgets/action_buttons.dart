import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stream_challenge/data/models/challenge.dart';

ElevatedButton endChallengeButton(
  VoidCallback onEnd,
) {
  return ElevatedButton(
    onPressed: onEnd,
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(
        const Color.fromARGB(255, 23, 185, 104),
      ),
      minimumSize: WidgetStateProperty.all<Size>(const Size(500, 40)),
    ),
    child: const Text("End", style: TextStyle(color: Colors.white)),
  );
}

List<Widget> getActionButtons(
  BuildContext context,
  VoidCallback onAccept,
  VoidCallback onReject,
  VoidCallback onReport,
) {
  return [
    ElevatedButton(
      onPressed: onAccept,
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(
              const Color.fromARGB(255, 127, 209, 130)),
          minimumSize: WidgetStateProperty.all<Size>(const Size(180, 40))),
      child: const Text("Accept", style: TextStyle(color: Colors.white)),
    ),
    ElevatedButton(
      onPressed: onReject,
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(
              const Color.fromARGB(255, 217, 221, 217)),
          minimumSize: WidgetStateProperty.all<Size>(const Size(180, 40))),
      child: const Text("Reject", style: TextStyle(color: Colors.black)),
    ),
    ElevatedButton(
      onPressed: onReport,
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(
              const Color.fromARGB(186, 212, 3, 3)),
          minimumSize: WidgetStateProperty.all<Size>(const Size(180, 40))),
      child: const Text("Report", style: TextStyle(color: Colors.white)),
    ),
  ];
}

Row getAuthorInfo(ChallengeAuthor author) {
  return Row(children: [
    Text('Author: ${author.name}',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        )),
    CircleAvatar(
      radius: 20,
      backgroundImage: NetworkImage(author.urlImage),
    )
  ]);
}

class ChallengeInfoWidget extends StatelessWidget {
  final Challenge challenge;

  const ChallengeInfoWidget({super.key, required this.challenge});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Bet: ${challenge.bet} ${challenge.currency}'),
      Text('Due: ${DateFormat('dd.MM.yyyy HH:mm').format(challenge.due_at)}'),
      const SizedBox(height: 8),
      Text('Conditions:', style: Theme.of(context).textTheme.titleMedium),
      ...challenge.conditions.map((condition) => Text('- $condition')),
      const SizedBox(height: 16),
    ]);
  }
}
