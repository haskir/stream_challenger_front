import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stream_challenge/common/mixins.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/feature/create_challenge/widgets/bet_slider.dart';
import 'package:stream_challenge/providers/challenge_provider.dart';
import 'package:stream_challenge/providers/providers.dart';
import 'package:stream_challenge/use_cases/challenges_actions.dart';
import '_actions_builder.dart';
import '_staring_widget.dart';

class AuthorActionsState extends ConsumerState<ActionsBuilder> {
  Challenge get challenge => widget.challenge;

  @override
  Widget build(BuildContext context) {
    // Author
    if (challenge.status == 'SUCCESSFUL') {
      return StarRatingWidget(
        isAuthor: true,
        onRatingChanged: (int rating) async {
          final bool? result = await Mixins.showConfDialog(
            context,
          );
          if (result == null || !result) return;
          await _rateChallenge(ref, rating);
        },
        initialRating: challenge.rating,
      );
    }
    if (widget.challenge.status == 'PENDING') {
      return ElevatedButton(
        onPressed: () async {
          final bool? result = await Mixins.showConfDialog(
            context,
          );
          if (result == null || !result) return;
          await _cancelChallenge(ref);
        },
        style: TextButton.styleFrom(foregroundColor: Colors.red),
        child: Row(children: [
          Text(AppLocale.of(context).translate('Cancel')),
          const SizedBox(width: 5),
          Icon(Icons.cancel),
        ]),
      );
    }
    if (challenge.status == 'FAILED' && challenge.payout == null) {
      TextEditingController controller = TextEditingController();
      return Center(
        child: SizedBox(
          height: 150,
          width: 500,
          child: Column(
            children: [
              BetSlider(
                controller: controller,
                minBet: 0.0,
                balance: challenge.bet,
                currency: challenge.currency,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (await Mixins.showConfDialog(context) ?? false) {
                    double amount =
                        double.parse(controller.text) / challenge.bet;
                    controller.dispose();
                    await _payChallenge(ref, amount);
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocale.of(context).translate('Pay')),
                    Icon(Icons.attach_money),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Container();
  }

  Future<void> _payChallenge(ref, double decimalPercentage) async {
    final client = await ref.watch(httpClientProvider.future);
    widget.onLoading(true);
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
      result.fold((left) {}, (right) {
        challenge.payout = right.payout;
        setState(() {});
      });
    });
    widget.onLoading(false);
  }

  Future<void> _cancelChallenge(ref) async {
    final client = await ref.watch(httpClientProvider.future);
    widget.onLoading(true);
    final result = await ChallengesActions.challengeAction(
      challenge: challenge,
      requester: client,
      action: 'cancel',
    );
    await result.fold((left) {
      Fluttertoast.showToast(msg: result.toString());
    }, (right) async {
      challenge.status = 'CANCELED';
      setState(() {});
    });
    widget.onLoading(false);
  }

  Future<void> _rateChallenge(ref, int rating) async {
    final client = await ref.watch(httpClientProvider.future);
    widget.onLoading(true);
    final result = await ChallengesActions.rateChallenge(
      challenge: challenge,
      client: client,
      rating: rating,
    );
    await result.fold((left) {
      Fluttertoast.showToast(msg: result.toString());
    }, (right) async {
      final result =
          await ChallengeGetter.getChallenge(id: challenge.id, client: client);
      result.fold((left) {}, (right) {
        challenge.rating = right.rating;
        setState(() {});
      });
    });
    widget.onLoading(false);
  }
}
