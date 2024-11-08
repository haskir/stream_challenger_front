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
    TextButton(
      onPressed: onReject,
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(
              const Color.fromARGB(255, 145, 144, 144)),
          minimumSize: WidgetStateProperty.all<Size>(const Size(180, 40))),
      child: const Row(children: [
        Icon(Icons.close),
        Text("Reject", style: TextStyle(color: Colors.white))
      ]),
    ),
    TextButton(
      onPressed: onAccept,
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(
              const Color.fromARGB(255, 127, 209, 130)),
          minimumSize: WidgetStateProperty.all<Size>(const Size(180, 40))),
      child: const Row(children: [
        Icon(Icons.check),
        Text("Accept", style: TextStyle(color: Colors.white))
      ]),
    ),
    TextButton(
      onPressed: onReport,
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(
              const Color.fromARGB(186, 212, 3, 3)),
          minimumSize: WidgetStateProperty.all<Size>(const Size(80, 40))),
      child: const Row(children: [
        Icon(Icons.report_outlined),
        Text("Report", style: TextStyle(color: Colors.white))
      ]),
    ),
  ];
}

Row getAuthorInfo(ChallengeAuthor author) {
  return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
    Text(author.name),
    CircleAvatar(
      radius: 15,
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
      Row(children: [
        const Text('Bet:'),
        Text(
          ' ${challenge.bet} ${challenge.currency}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ]),
      Text('Due: ${DateFormat('dd.MM.yyyy HH:mm').format(challenge.due_at)}'),
      const SizedBox(height: 8),
      Text('Conditions:', style: Theme.of(context).textTheme.titleMedium),
      ...challenge.conditions.map((condition) => Text('- $condition')),
      const SizedBox(height: 16),
    ]);
  }
}
