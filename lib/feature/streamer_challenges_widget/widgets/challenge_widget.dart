import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/feature/streamer_challenges_widget/challenges_actions.dart';
import 'package:stream_challenge/providers.dart';
import 'action_buttons.dart';

class ChallengeWidgetWithActions extends ConsumerStatefulWidget {
  final Challenge challenge;

  const ChallengeWidgetWithActions({
    super.key,
    required this.challenge,
    //required this.requester,
  });

  @override
  ConsumerState<ChallengeWidgetWithActions> createState() =>
      _ChallengeWidgetWithActionsState();
}

class _ChallengeWidgetWithActionsState
    extends ConsumerState<ChallengeWidgetWithActions> {
  late Challenge challenge;

  @override
  void initState() {
    super.initState();
    challenge = widget.challenge;
  }

  Text getStatusText(Challenge challenge) {
    switch (challenge.status) {
      case "COMPLETED":
        return Text(AppLocalizations.of(context).translate("Status: Completed"),
            style: TextStyle(color: Colors.green));
      case "REJECTED":
        return Text(AppLocalizations.of(context).translate("Status: Rejected"),
            style: TextStyle(color: Colors.red));
      case "ACCEPTED":
        return Text(
            AppLocalizations.of(context).translate("Status: In Progress"),
            style: TextStyle(color: Colors.blue));
      default:
        return Text(AppLocalizations.of(context).translate("Status: Hidden"),
            style: TextStyle(color: Colors.grey));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              challenge.description,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ChallengeInfoWidget(challenge: challenge),
            const SizedBox(height: 8),
            if (challenge.status == "PENDING") ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: getActionButtons(
                  context: context,
                  doAccept: () async {
                    print("accept");
                    final requester = await ref.read(httpClientProvider.future);
                    await ChallengesActions().acceptChallenge(
                      challenge,
                      requester,
                    );
                  }, //() => acceptChallenge(challenge, widget.requester),
                  doReject: () {
                    print("reject");
                  }, //() => rejectChallenge(challenge, widget.requester),
                  doReport: () {
                    print("report");
                  }, //() => reportChallenge(challenge, widget.requester),
                ),
              ),
            ] else if (challenge.status == "ACCEPTED") ...[
              Center(child: endChallengeButton(context)),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: getStatusText(challenge),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: getAuthorInfo(challenge.author),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
