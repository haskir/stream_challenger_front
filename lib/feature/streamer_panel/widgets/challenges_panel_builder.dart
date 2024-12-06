import 'package:flutter/material.dart';
import 'package:stream_challenge/common/consts.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/feature/challenge_view/challenge_card.dart';

class ChallengesPanelBuilder {
  final Map<String, bool> expandedStates;

  ChallengesPanelBuilder({
    required this.expandedStates,
  });

  List<ExpansionPanel>? cachedPanels;

  List<ExpansionPanel> buildExpansionPanels(
      BuildContext context, Map<String, List<Challenge>> challengesByStatus) {
    if (cachedPanels != null) {
      return cachedPanels!;
    }

    cachedPanels = challengesByStatus.entries.map((entry) {
      final status = entry.key;
      final List<Challenge> challenges = entry.value;

      return ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) {
          return ListTile(
            title: Center(
                child: Text(AppLocale.of(context)
                    .translate(challengesStatusHeaders[status]!))),
            trailing: Text('(${challenges.length})',
                style: TextStyle(
                  color: challengesStatusColors[status],
                  fontSize: 18,
                )),
          );
        },
        body: challenges.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: challenges.length,
                itemBuilder: (context, index) {
                  final challenge = challenges[index];
                  return ChallengeCard(
                    key: ObjectKey(challenge),
                    isAuthor: false,
                    challenge: challenge,
                  );
                },
              )
            : const SizedBox.shrink(),
        isExpanded: challenges.isNotEmpty && expandedStates[status]!,
        canTapOnHeader: true,
      );
    }).toList();
    return cachedPanels!;
  }
}
