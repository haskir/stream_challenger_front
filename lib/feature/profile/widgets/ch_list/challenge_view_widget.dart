import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stream_challenge/common/mixins.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/feature/create_challenge/widgets/bet_slider.dart';

class _Info extends StatelessWidget {
  final Challenge challenge;
  const _Info({super.key, required this.challenge});

  @override
  Widget build(BuildContext context) {
    String condText = '${AppLocale.of(context).translate('Conditions')}:\n';
    for (String condition in challenge.conditions) {
      condText += '- $condition\n';
    }
    String holdText = '${AppLocale.of(context).translate('Hold until: ')}: ';
    holdText += DateFormat('dd.MM.yyyy')
        .format(challenge.createdAt.add(Duration(days: 7)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('${AppLocale.of(context).translate('Description')}: '),
            Text(' ${challenge.description}')
          ],
        ),
        if (challenge.conditions.isNotEmpty) Text(condText),
        Row(
          children: [
            Text('${AppLocale.of(context).translate('Bet')}:'),
            const SizedBox(width: 5),
            Text(' ${challenge.bet} ${challenge.currency}'),
            const SizedBox(width: 15),
            // Челендж не оплачен
            if (challenge.status == 'FAILED' && challenge.payout == null)
              Row(
                children: [
                  Text(
                    '${AppLocale.of(context).translate("Didn't pay")}:',
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.close, color: Colors.red),
                ],
              ),
            // Челендж оплачен
            if (challenge.status == 'FAILED' && challenge.payout != null)
              Row(
                children: [
                  Text(
                    '${AppLocale.of(context).translate('Payed')}: ${challenge.payout} ${challenge.currency}',
                    style: TextStyle(color: Colors.green),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.check),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

class ChallengeViewPerformer extends StatelessWidget {
  final Challenge challenge;

  const ChallengeViewPerformer({
    super.key,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _Info(challenge: challenge),
            Mixins.personInfo(challenge.author),
          ],
        ),
      ),
    );
  }
}

class ChallengeViewAuthor extends StatelessWidget {
  final TextEditingController? controller;
  final Challenge challenge;
  ChallengeViewAuthor({
    super.key,
    required this.challenge,
  }) : controller = challenge.status == 'FAILED' && challenge.payout == null
            ? TextEditingController()
            : null;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Info(challenge: challenge),
                if (controller != null)
                  SizedBox(
                    height: 150,
                    width: 500,
                    child: BetSlider(
                      controller: controller!,
                      minBet: 0.0,
                      balance: challenge.bet,
                      currency: challenge.currency,
                    ),
                  ),
                Row(
                  children: [
                    Text('${AppLocale.of(context).translate('Created At')}: '),
                    Text(DateFormat('dd.MM.yyyy').format(challenge.createdAt)),
                    SizedBox(width: 20),
                    Mixins.personInfo(challenge.performer),
                    SizedBox(width: 20),
                    if (controller != null)
                      ElevatedButton(
                        onPressed: () async {
                          await Mixins.showConfDialog(context);
                        },
                        child: Text(AppLocale.of(context).translate('Pay')),
                      ),
                    if (challenge.status == 'PENDING')
                      ElevatedButton(
                        onPressed: () async {
                          await Mixins.showConfDialog(context);
                        },
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.red),
                        child: Row(children: [
                          Text(AppLocale.of(context).translate('Cancel')),
                          const SizedBox(width: 5),
                          Icon(Icons.cancel),
                        ]),
                      )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
