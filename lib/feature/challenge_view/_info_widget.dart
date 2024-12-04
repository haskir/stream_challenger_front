import 'package:flutter/material.dart';
import 'package:stream_challenge/common/mixins.dart';
import 'package:stream_challenge/common/text_consts.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/data/models/challenge.dart';

class InfoWidget extends StatelessWidget {
  final Challenge challenge;

  const InfoWidget({super.key, required this.challenge});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${AppLocale.of(context).translate(mConditions)}:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  ...challenge.conditions
                      .map((condition) => Text('- $condition')),
                ],
              ),
          ],
        ),
        SizedBox(height: 35),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ставка
            _buildBet(challenge, context),
            SizedBox(width: 35),
            // Статус
            _buildStatus(challenge.status, context),
          ],
        ),
      ],
    );
  }

  Widget _buildBet(Challenge challenge, BuildContext context) {
    if (challenge.status == "FAILED") {
      return Row(
        children: [
          Text("${AppLocale.of(context).translate(mBet)}: "),
          Text(
            '${challenge.bet} ${challenge.currency}',
            style:
                const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          if (challenge.payout != null) ...[
            const SizedBox(width: 10),
            Text(
              '${AppLocale.of(context).translate(mPayout)}: ',
            ),
            Text(
              challenge.payout!.toStringAsFixed(2),
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.green),
            ),
            Text(' ${challenge.currency}')
          ]
        ],
      );
    }
    return Row(
      children: [
        Text(
          '${challenge.bet} ${challenge.currency}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget _buildStatus(String status, BuildContext context) {
    switch (status) {
      case 'PENDING':
        return Text(
          AppLocale.of(context).translate(mPending),
          style: TextStyle(color: Colors.orange),
        );
      case 'ACCEPTED':
        return Text(
          AppLocale.of(context).translate(mAccepted),
          style: TextStyle(color: Colors.blue),
        );
      case 'SUCCESSFUL':
        return Text(
          AppLocale.of(context).translate(mSuccessful),
          style: TextStyle(color: Colors.green),
        );
      case 'FAILED':
        return Text(
          AppLocale.of(context).translate(mFailed),
          style: TextStyle(color: Colors.red),
        );
      case 'CANCELLED':
        return Text(
          AppLocale.of(context).translate(mCancelled),
          style: TextStyle(color: Colors.grey),
        );
      case 'REJECTED':
        return Text(
          AppLocale.of(context).translate(mRejected),
          style: TextStyle(color: Colors.red),
        );
      case 'REPORTED':
        return Text(
          AppLocale.of(context).translate(mReported),
          style: TextStyle(color: Colors.red),
        );
      default:
        return Center(child: Text(status));
    }
  }
}
