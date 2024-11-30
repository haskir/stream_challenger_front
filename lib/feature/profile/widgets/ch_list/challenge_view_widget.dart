import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:stream_challenge/common/mixins.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/feature/create_challenge/widgets/bet_slider.dart';
import 'package:stream_challenge/providers/challenge_provider.dart';
import 'package:stream_challenge/providers/providers.dart';
import 'package:stream_challenge/use_cases/challenges_actions.dart';

class _Info extends StatelessWidget {
  final Challenge challenge;
  const _Info({super.key, required this.challenge});

  @override
  Widget build(BuildContext context) {
    String condText = '${AppLocale.of(context).translate('Conditions')}:\n';
    for (String condition in challenge.conditions) {
      condText += '- $condition\n';
    }
    String holdText = '${AppLocale.of(context).translate('Hold until')}: ';
    holdText += DateFormat('(dd.MM.yyyy)')
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
                  SizedBox(width: 5),
                  Text(holdText),
                  SizedBox(width: 5),
                ],
              ),
            // Челендж оплачен
            if (challenge.status == 'FAILED' && challenge.payout != null)
              Row(
                children: [
                  Text(
                    '${AppLocale.of(context).translate('Paid')}: ${challenge.payout?.toStringAsFixed(2)} ${challenge.currency}',
                    style: TextStyle(color: Colors.green),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.check, color: Colors.green),
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

class ChallengeViewAuthor extends ConsumerStatefulWidget {
  final Challenge challenge;
  const ChallengeViewAuthor({
    super.key,
    required this.challenge,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ChallengeViewAuthorState();
  }
}

class _ChallengeViewAuthorState extends ConsumerState<ChallengeViewAuthor> {
  Challenge get challenge => widget.challenge;
  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    controller = challenge.status == 'FAILED' && challenge.payout == null
        ? TextEditingController()
        : null;
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
                          final bool? result = await Mixins.showConfDialog(
                            context,
                          );
                          if (result == null) return;
                          if (!result) return;
                          await _payChallenge(
                            ref,
                            double.parse(controller!.text) / challenge.bet,
                          );
                        },
                        child: Text(AppLocale.of(context).translate('Pay')),
                      ),
                    if (challenge.status == 'PENDING')
                      ElevatedButton(
                        onPressed: () async {
                          final bool? result = await Mixins.showConfDialog(
                            context,
                          );
                          if (result == null) return;
                          if (!result) return;
                          await _cancelChallenge(ref);
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

  Future<void> _payChallenge(ref, double decimalPercentage) async {
    final client = await ref.watch(httpClientProvider.future);
    final result = await ChallengesActions.payFailedChallenge(
      challenge: challenge,
      decimalPercentage: decimalPercentage,
      client: client,
    );
    await result.fold((left) {
      Fluttertoast.showToast(msg: result.toString());
    }, (right) async {
      final result =
          await ChallengeGetter.getChallenge(id: challenge.id, client: client);
      result.fold((left) {
        print("Error getting challenge ${left.message}");
      }, (right) {
        challenge.payout = right.payout;
        print("Updated payout: ${challenge.payout}");
        setState(() {});
      });
    });
  }

  Future<void> _cancelChallenge(ref) async {
    final client = await ref.watch(httpClientProvider.future);
    final result = await ChallengesActions.challengeAction(
      challenge: challenge,
      requester: client,
      action: 'cancel',
    );
    await result.fold((left) {
      Fluttertoast.showToast(msg: result.toString());
    }, (right) async {
      challenge.status = 'CANCELED';
      controller?.dispose();
      controller = null;
      setState(() {});
    });
  }
}
