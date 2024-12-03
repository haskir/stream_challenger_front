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
        Tooltip(
          message: AppLocale.of(context).translate('End'),
          child: ElevatedButton(
              onPressed: () => actionCallback("END"),
              child: Icon(
                Icons.check_box_outlined,
                color: Colors.green,
              )),
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
              color: Colors.orange,
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

  Widget _buildStatus(String status, BuildContext context) {
    switch (status) {
      case 'PENDING':
        return Text(
          '(${AppLocale.of(context).translate('Pending')})',
          style: TextStyle(color: Colors.orange),
        );
      case 'ACCEPTED':
        return Text(
          '(${AppLocale.of(context).translate('Accepted')})',
          style: TextStyle(color: Colors.blue),
        );
      default:
        return Text("ERROR");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Аватарка
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 15, 15),
                  child: Mixins.personInfo(challenge.author, context, 25),
                ),
                // Описание
                Flexible(
                  child: Text(
                    challenge.description,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            if (challenge.conditions.isNotEmpty)
              // Условия
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppLocale.of(context).translate('Conditions')}:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  ...challenge.conditions
                      .map((condition) => Text('- $condition')),
                ],
              ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${challenge.bet} ${challenge.currency}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 35),
            _buildStatus(challenge.status, context),
          ],
        ),
      ],
    );
  }
}
