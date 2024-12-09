import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stream_challenge/common/mixins.dart';
import 'package:stream_challenge/common/text_consts.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/core/platform/dio.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/providers/providers.dart';
import 'package:stream_challenge/use_cases/challenges_actions.dart';

import '../streamer_panel/widgets/report_dialog.dart';
import '_actions_builder.dart';
import '_staring_widget.dart';

class PerformerActionsState extends ConsumerState<ActionsBuilder> {
  Challenge get challenge => widget.challenge;
  static const bool isAuthor = false;

  @override
  Widget build(BuildContext context) {
    if (widget.challenge.status == 'SUCCESSFUL') {
      return StarRatingWidget(
        isAuthor: false,
        initialRating: challenge.rating,
      );
    }
    return _getActionButtons(
      status: widget.challenge.status,
      context: context,
      actionCallback: (action) async {
        if (action == "REPORT") {
          return await _reportChallenge(
            challenge,
            await ref.read(httpClientProvider.future),
          );
        }
        if (await Mixins.showConfDialog(context) ?? false) {
          await _challengeAction(
            challenge,
            await ref.read(httpClientProvider.future),
            action,
          );
        }
      },
    );
  }

  Row _getActionButtons({
    required String status,
    required BuildContext context,
    required Function(String action) actionCallback,
  }) {
    switch (status) {
      case 'ACCEPTED':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (challenge.predictID == null) ...[
              ElevatedButton(
                onPressed: () => actionCallback("START_PREDICT"),
                child: Text(AppLocale.of(context).translate(mStartPredict)),
              ),
              SizedBox(width: 5),
            ],
            if (challenge.pollID == null) ...[
              ElevatedButton(
                onPressed: () => actionCallback("START_POLL"),
                child: Text(AppLocale.of(context).translate(mStartPoll)),
              ),
            ]
          ],
        );
      case 'PENDING':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Accept Button
            Tooltip(
              message: AppLocale.of(context).translate(mAccept),
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
              message: AppLocale.of(context).translate(mReject),
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
              message: AppLocale.of(context).translate(mReport),
              child: ElevatedButton(
                onPressed: () => actionCallback("REPORT"),
                child: const Icon(
                  Icons.report_problem_outlined,
                  color: Colors.orange,
                ),
              ),
            ),
          ],
        );
      default:
        return Row(children: []);
    }
  }

  Future? _reportChallenge(
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
              msg: AppLocale.of(context).translate(mReported)));
    }
  }

  Future _challengeAction(
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
}
