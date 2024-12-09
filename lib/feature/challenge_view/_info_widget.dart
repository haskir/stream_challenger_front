import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_challenge/common/mixins.dart';
import 'package:stream_challenge/common/text_consts.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/data/models/challenge.dart';

class InfoWidget extends StatelessWidget {
  final bool? isAuthor;
  final Challenge challenge;
  final Widget actions;

  const InfoWidget({
    super.key,
    required this.isAuthor,
    required this.challenge,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 200),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      // Аватарка
                      child: Mixins.personInfo(
                        (isAuthor == true)
                            ? challenge.performer
                            : challenge.author,
                        context,
                        25,
                      ),
                    ),
                    if (kDebugMode) Text('${challenge.id}  '),
                    // Описание
                    Flexible(
                      child: Text(
                        challenge.description,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
              // Действия
              Container(alignment: Alignment.bottomRight, child: actions),
            ],
          ),
          if (challenge.conditions.isNotEmpty)
            // Условия
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppLocale.of(context).translate(mConditions)}:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  ...challenge.conditions
                      .map((condition) => Text('- $condition')),
                ],
              ),
            ),
          // Прогноз и голосование
          if (isAuthor == false && challenge.status == "ACCEPTED")
            _buildPredictAndPoll(challenge, context),
          // Ставка и статус (снизу)
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBet(challenge, context),
              SizedBox(width: 35),
              _buildStatus(challenge.status, context),
            ],
          ),
        ],
      ),
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

  Widget _buildPredictAndPoll(Challenge challenge, BuildContext context) {
    return Column(
      children: [
        // Predict
        Row(
          children: [
            Text(AppLocale.of(context).translate(mPredictStarted),
                style: TextStyle(
                    color: (challenge.predictID != null)
                        ? Colors.green
                        : Colors.red)),
            Icon((challenge.predictID != null) ? Icons.check : Icons.close),
          ],
        ),
        // Poll
        Row(
          children: [
            Text(AppLocale.of(context).translate(mPollStarted),
                style: TextStyle(
                    color: (challenge.pollID != null)
                        ? Colors.green
                        : Colors.red)),
            Icon((challenge.pollID != null) ? Icons.check : Icons.close),
          ],
        )
      ],
    );
  }
}
