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

class ChalellengeInfo extends StatelessWidget {
  final Challenge challenge;
  const ChalellengeInfo({super.key, required this.challenge});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ChallengeCard extends ConsumerStatefulWidget {
  final Challenge challenge;

  const ChallengeCard({
    super.key,
    required this.challenge,
  });

  @override
  ConsumerState<ChallengeCard> createState() => ChallengeCardState();
}

class ChallengeCardState extends ConsumerState<ChallengeCard> {
  Challenge get challenge => widget.challenge;

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
        minHeight: 100,
        maxHeight: 300,
        maxWidth: 700,
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                flex: 5,
                child: ChallengeInfoWidget(challenge: challenge),
              ),
              Spacer(),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
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
