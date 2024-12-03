import 'package:flutter/material.dart';
import 'package:stream_challenge/common/mixins.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/data/models/challenge.dart';

class ChallengeInfoWidget extends StatelessWidget {
  final Challenge challenge;

  const ChallengeInfoWidget({super.key, required this.challenge});

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

  Widget _buildStatus(String status, BuildContext context) {
    switch (status) {
      case 'PENDING':
        return Text(
          AppLocale.of(context).translate('Pending'),
          style: TextStyle(color: Colors.orange),
        );
      case 'ACCEPTED':
        return Text(
          AppLocale.of(context).translate('Accepted'),
          style: TextStyle(color: Colors.blue),
        );
      case 'SUCCESSFUL':
        return Text(
          AppLocale.of(context).translate('Successful'),
          style: TextStyle(color: Colors.green),
        );
      case 'FAILED':
        return Text(
          AppLocale.of(context).translate('Failed'),
          style: TextStyle(color: Colors.red),
        );
      case 'CANCELLED':
        return Text(
          AppLocale.of(context).translate('Cancelled'),
          style: TextStyle(color: Colors.grey),
        );
      case 'REJECTED':
        return Text(
          AppLocale.of(context).translate('Rejected'),
          style: TextStyle(color: Colors.red),
        );
      case 'REPORTED':
        return Text(
          AppLocale.of(context).translate('Reported'),
          style: TextStyle(color: Colors.red),
        );
      default:
        return Center(child: Text(status));
    }
  }
}
