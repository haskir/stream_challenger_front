import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/feature/streamer_panel/widgets/challenge_widget.dart';

class ChallengesPanelBuilder {
  static const Map<String, String> headers = {
    'ACCEPTED': "Accepted Challenges",
    "ENDED": "Waiting for voting",
    'PENDING': "New Challenges",
    'REJECTED': "Rejected Challenges",
    'FAILED': "Failed Challenges",
    'HIDDEN': "Hidden Challenges",
    'SUCCESSFUL': "Successful Challenges",
  };
  static const Map<String, Color> colors = {
    'ACCEPTED': Colors.blue,
    'ENDED': Colors.yellow,
    'PENDING': Colors.orange,
    'REJECTED': Colors.red,
    'FAILED': Colors.black,
    'HIDDEN': Colors.grey,
    'SUCCESSFUL': Colors.green,
  };

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
      final challenges = entry.value;

      return ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) {
          return ListTile(
            title: Text(AppLocale.of(context).translate(headers[status]!)),
            trailing: Text('(${challenges.length})',
                style: TextStyle(
                  color: colors[status],
                  fontSize: 18,
                )),
          );
        },
        body: Column(
          children: challenges
              .map((challenge) => ChallengeWidgetWithActions(
                  key: ObjectKey(challenge), challenge: challenge))
              .toList(),
        ),
        isExpanded: challenges.isNotEmpty && expandedStates[status]!,
        canTapOnHeader: true,
      );
    }).toList();

    return cachedPanels!;
  }
}

void debugPanels(Map<String, List<Challenge>> challengesByState) {
  if (!kDebugMode) {
    return;
  }
  for (var entry in challengesByState.entries) {
    if (entry.value.isEmpty) continue;
    String ids = "${entry.key}:";
    for (var challenge in entry.value) {
      ids += " ${challenge.id}";
    }
    if (kDebugMode) {
      print(ids);
    }
  }
  if (kDebugMode) {
    print("-------");
  }
}
