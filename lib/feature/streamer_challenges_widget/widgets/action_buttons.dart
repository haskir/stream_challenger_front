import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/data/models/challenge.dart';

import '../challenges_actions.dart';

ElevatedButton endChallengeButton(context) {
  return ElevatedButton(
    onPressed: () {},
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(
        const Color.fromARGB(255, 23, 185, 104),
      ),
      minimumSize: WidgetStateProperty.all<Size>(const Size(500, 40)),
    ),
    child: Text(AppLocalizations.of(context).translate('End'),
        style: TextStyle(color: Colors.white)),
  );
}

List<Widget> getActionButtons({
  required BuildContext context,
  required VoidCallback doAccept,
  required VoidCallback doReject,
  required VoidCallback doReport,
}) {
  return [
    // Reject Button
    TextButton(
      onPressed: doReject,
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all<Size>(const Size(180, 40)),
        backgroundColor: WidgetStateProperty.all<Color>(
            const Color.fromARGB(255, 145, 144, 144)),
      ),
      child: Row(children: [
        Icon(Icons.close),
        Text(AppLocalizations.of(context).translate('Reject'),
            style: TextStyle(color: Colors.white))
      ]),
    ),
    // Accept Button
    TextButton(
      onPressed: doAccept,
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all<Size>(const Size(180, 40)),
        backgroundColor: WidgetStateProperty.all<Color>(
            const Color.fromARGB(255, 127, 209, 130)),
      ),
      child: Row(children: [
        Icon(Icons.check),
        Text(AppLocalizations.of(context).translate('Accept'),
            style: TextStyle(color: Colors.white))
      ]),
    ),
    // Report Button
    TextButton(
      onPressed: doReport,
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all<Size>(const Size(80, 40)),
        backgroundColor: WidgetStateProperty.all<Color>(
            const Color.fromARGB(186, 212, 3, 3)),
      ),
      child: Row(children: [
        Icon(Icons.report_outlined),
        Text(AppLocalizations.of(context).translate('Report'),
            style: TextStyle(color: Colors.white))
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
        Text('${AppLocalizations.of(context).translate('Bet')}:'),
        Text(
          ' ${challenge.bet} ${challenge.currency}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ]),
      Text(
          '${AppLocalizations.of(context).translate('Due')}: ${DateFormat('dd.MM.yyyy HH:mm').format(challenge.due_at)}'),
      const SizedBox(height: 8),
      Text('${AppLocalizations.of(context).translate('Conditions')}:',
          style: Theme.of(context).textTheme.titleMedium),
      ...challenge.conditions.map((condition) => Text('- $condition')),
      const SizedBox(height: 16),
    ]);
  }
}
