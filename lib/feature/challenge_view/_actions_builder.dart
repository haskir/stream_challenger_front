import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stream_challenge/common/mixins.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/core/platform/dio.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/feature/create_challenge/widgets/bet_slider.dart';
import 'package:stream_challenge/providers/challenge_provider.dart';
import 'package:stream_challenge/providers/providers.dart';
import 'package:stream_challenge/use_cases/challenges_actions.dart';

import '../streamer_panel/widgets/report_dialog.dart';

class ChallengeActionsBuilder extends ConsumerStatefulWidget {
  final Challenge challenge;
  final bool isAuthor;
  final Function(bool isLoading) onLoading;

  const ChallengeActionsBuilder({
    super.key,
    required this.challenge,
    required this.isAuthor,
    required this.onLoading,
  });

  @override
  createState() => _ChallengeActionBuilderState();
}

class _ChallengeActionBuilderState
    extends ConsumerState<ChallengeActionsBuilder> {
  late final TextEditingController? controller;

  Challenge get challenge => widget.challenge;

  @override
  Widget build(BuildContext context) {
    if (!widget.isAuthor) {
      return _getActionButtons(
        status: widget.challenge.status,
        context: context,
        actionCallback: (action) async {
          if (action == "REPORT") {
            return await reportChallenge(
              challenge,
              await ref.read(httpClientProvider.future),
            );
          }
          if (await Mixins.showConfDialog(context) ?? false) {
            await challengeAction(
              challenge,
              await ref.read(httpClientProvider.future),
              action,
            );
          }
        },
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
    if (widget.challenge.status == 'FAILED' && challenge.payout == null) {
      controller = TextEditingController();
      return SizedBox(
        height: 150,
        width: 500,
        child: BetSlider(
          controller: controller!,
          minBet: 0.0,
          balance: challenge.bet,
          currency: challenge.currency,
        ),
      );
    }
    return Container();
  }

  Row _getActionButtons({
    required String status,
    required BuildContext context,
    required Function(String action) actionCallback,
  }) {
    switch (status) {
      case 'ACCEPTED':
        return Row(mainAxisSize: MainAxisSize.min, children: [
          Tooltip(
            message: AppLocale.of(context).translate('End'),
            child: ElevatedButton(
                onPressed: () => actionCallback("END"),
                child: Icon(
                  Icons.check_box_outlined,
                  color: Colors.green,
                )),
          )
        ]);
      case 'ENDED':
        return Row(mainAxisSize: MainAxisSize.min, children: [
          ElevatedButton(
            onPressed: () => actionCallback("START_POLL"),
            child: Text(AppLocale.of(context).translate('Start poll'),
                style: TextStyle(color: Colors.white)),
          )
        ]);
      case 'PENDING':
        return Row(mainAxisSize: MainAxisSize.min, children: [
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
        ]);
      default:
        return Row(children: []);
    }
  }

  Future? reportChallenge(
    Challenge challenge,
    Requester client,
  ) async {
    CreateReportDTO? report = await showDialog<CreateReportDTO?>(
      context: context,
      builder: (context) => ReportDialog(challengeId: challenge.id),
    );
    if (report == null) {
      return null;
    }
    widget.onLoading(true);
    final Either result = await ChallengesActions.reportChallege(
      challenge: challenge,
      client: client,
      report: report,
    );
    widget.onLoading(false);

    if (mounted) {
      return result.fold(
          (left) => Fluttertoast.showToast(msg: result.toString()),
          (right) => Fluttertoast.showToast(
              msg: AppLocale.of(context).translate("Reported")));
    }
  }

  Future challengeAction(
      Challenge challenge, Requester requester, String action) async {
    widget.onLoading(true);

    final result = await ChallengesActions.challengeAction(
      challenge: challenge,
      requester: requester,
      action: action,
    );

    result.fold(
        (left) => Fluttertoast.showToast(
            msg: left.message,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            timeInSecForIosWeb: 10),
        (right) => null);
    if (mounted) {
      widget.onLoading(false);
    }
    return result;
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
      result.fold((left) {
        print("Error getting challenge ${left.message}");
      }, (right) {
        challenge.payout = right.payout;
        print("Updated payout: ${challenge.payout}");
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
      controller?.dispose();
      controller = null;
      setState(() {});
    });
    widget.onLoading(false);
  }
}
