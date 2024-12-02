import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stream_challenge/common/mixins.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/core/platform/dio.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/use_cases/challenges_actions.dart';
import 'package:stream_challenge/providers/providers.dart';
import 'action_buttons.dart';
import 'report_dialog.dart';

class ChallengeWidgetWithActions extends ConsumerStatefulWidget {
  final Challenge challenge;

  const ChallengeWidgetWithActions({
    super.key,
    required this.challenge,
  });

  @override
  ConsumerState<ChallengeWidgetWithActions> createState() =>
      _ChallengeWidgetWithActionsState();
}

class _ChallengeWidgetWithActionsState
    extends ConsumerState<ChallengeWidgetWithActions> {
  late Challenge challenge;
  //bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    challenge = widget.challenge;
  }

  Text getStatusText(Challenge challenge) {
    String text = "${AppLocale.of(context).translate("Status")}: ";
    text += AppLocale.of(context).translate(challenge.status);
    const Map colors = {
      "ENDED": Colors.blueAccent,
      "SUCCESSFUL": Colors.green,
      "FAILED": Colors.black,
      "REJECTED": Colors.red,
      "ACCEPTED": Colors.blue,
      "PENDING": Colors.orange,
    };
    return Text(text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: colors[challenge.status] ?? Colors.grey,
        ));
  }

  Future challengeAction(
      Challenge challenge, Requester requester, String action) async {
    setState(() {
      //_isLoading = true;
    });

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
      setState(() {
        //_isLoading = false;
      });
    }
    return result;
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
    final Either result = await ChallengesActions.reportChallege(
      challenge: challenge,
      client: client,
      report: report,
    );

    if (mounted) {
      return result.fold(
          (left) => Fluttertoast.showToast(msg: result.toString()),
          (right) => Fluttertoast.showToast(
              msg: AppLocale.of(context).translate("Reported")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 500,
        maxWidth: 1300,
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              ChallengeInfoWidget(challenge: challenge),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Bet
                  Text(
                    '${challenge.bet} ${challenge.currency}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // Buttons
                  Row(
                    children: getActionButtons(
                      status: challenge.status,
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
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      /* if (_isLoading)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
              //child: const ModalBarrier(),
            ),
          if (_isLoading) const Center(child: CircularProgressIndicator()), */
    );
  }
}
