import 'package:flutter/material.dart';
import 'package:stream_challenge/common/mixins.dart';
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
        TextButton(
          onPressed: () => actionCallback("END"),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
              const Color.fromARGB(255, 23, 185, 104),
            ),
            minimumSize: WidgetStateProperty.all<Size>(const Size(500, 40)),
          ),
          child: Row(
            children: [
              Text(AppLocale.of(context).translate('End'),
                  style: TextStyle(color: Colors.white)),
              Icon(Icons.check_box_outlined)
            ],
          ),
        )
      ];
    case 'ENDED':
      return [
        ElevatedButton(
          onPressed: () => actionCallback("START_POLL"),
          child: Text(AppLocale.of(context).translate('Start poll'),
              style: TextStyle(color: Colors.white)),
        )
      ];
    case 'PENDING':
      return [
        // Accept Button
        Tooltip(
          message: AppLocale.of(context).translate("Accept"),
          child: ElevatedButton(
            onPressed: () => actionCallback("ACCEPT"),
            child: const Icon(
              Icons.check,
              color: Colors.green,
            ),
          ),
        ),
        SizedBox(width: 5),
        // Reject Button
        Tooltip(
          message: AppLocale.of(context).translate("Reject"),
          child: ElevatedButton(
            onPressed: () => actionCallback("REJECT"),
            style: ButtonStyle(),
            child: const Icon(
              Icons.close,
              color: Colors.red,
            ),
          ),
        ),
        SizedBox(width: 5),
        // Report Button
        Tooltip(
          message: AppLocale.of(context).translate("Report"),
          child: ElevatedButton(
            onPressed: () => actionCallback("REPORT"),
            child: const Icon(
              Icons.report_problem_outlined,
              color: Colors.deepPurple,
            ),
          ),
        ),
      ];
    default:
      return [];
  }
}

class ChallengeInfoWidget extends StatelessWidget {
  final Challenge challenge;

  const ChallengeInfoWidget({super.key, required this.challenge});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 15, 15),
              child: Mixins.personInfo(challenge.author, 25),
            ),
            Flexible(
              child: Text(
                challenge.description,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
        if (challenge.conditions.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${AppLocale.of(context).translate('Conditions')}:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ...challenge.conditions.map((condition) => Text('- $condition')),
            ],
          ),
      ],
    );
  }
}
