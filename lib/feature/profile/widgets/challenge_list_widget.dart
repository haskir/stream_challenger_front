import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/feature/profile/widgets/challenges_panel_builder.dart';
import 'package:stream_challenge/providers/challenge_provider.dart';

class ChallengesListWidget extends ConsumerStatefulWidget {
  final bool isAuthor;
  late final challengesProvider;
  ChallengesListWidget({
    super.key,
    required this.isAuthor,
  }) : challengesProvider =
            isAuthor ? authorChallengesProvider : performerChallengesProvider;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ChallengesListWidgetState();
  }
}

class _ChallengesListWidgetState extends ConsumerState<ChallengesListWidget> {
  final Map<String, bool> _expandedStates = {
    //'ACCEPTED': false,
    'PENDING': false,
    'REJECTED': false,
    //'FAILED': false,
    //'CANCELLED': false,
    //'SUCCESSFUL': false,
  };
  final Map<String, List<Challenge>> challengesByStatus = {};

  @override
  Widget build(BuildContext context) {
    return ChallengesPanel(
      expandedStates: _expandedStates,
      challengesProvider: widget.challengesProvider,
    );
  }
}
