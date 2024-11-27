import 'package:flutter/material.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/data/models/challenge.dart';

List<Widget> getActionButtons({
  required String status,
  required BuildContext context,
  required Function(String action) actionCallback,
}) {
  switch (status) {
    case 'ACCEPTED':
      return [
        ElevatedButton(
          onPressed: () => actionCallback("END"),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
              const Color.fromARGB(255, 23, 185, 104),
            ),
            minimumSize: WidgetStateProperty.all<Size>(const Size(500, 40)),
          ),
          child: Text(AppLocalizations.of(context).translate('End'),
              style: TextStyle(color: Colors.white)),
        )
      ];
    case 'ENDED':
      return [
        ElevatedButton(
          onPressed: () => actionCallback("START_POLL"),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
              const Color.fromARGB(255, 23, 185, 104),
            ),
            minimumSize: WidgetStateProperty.all<Size>(const Size(500, 40)),
          ),
          child: Text(AppLocalizations.of(context).translate('Start poll'),
              style: TextStyle(color: Colors.white)),
        )
      ];
    case 'PENDING':
      return [
        // Reject Button
        TextButton(
          onPressed: () => actionCallback("REJECT"),
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
          onPressed: () => actionCallback("ACCEPT"),
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
          onPressed: () => actionCallback("REPORT"),
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
    default:
      return [];
  }
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
      const SizedBox(height: 8),
      if (challenge.conditions.isNotEmpty)
        Text('${AppLocalizations.of(context).translate('Conditions')}:',
            style: Theme.of(context).textTheme.titleMedium),
      ...challenge.conditions.map((condition) => Text('- $condition')),
      const SizedBox(height: 16),
    ]);
  }
}
