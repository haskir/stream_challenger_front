import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/feature/profile/widgets/ch_list/challenges_panel_builder.dart';

class ChallengesListWidget extends ConsumerStatefulWidget {
  final bool isAuthor;
  const ChallengesListWidget({
    super.key,
    required this.isAuthor,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ChallengesListWidgetState();
  }
}

class _ChallengesListWidgetState extends ConsumerState<ChallengesListWidget> {
  final Map<String, bool> _expandedStates = {
    'PENDING': false,
    'ACCEPTED': false,
    'REJECTED': false,
    'SUCCESSFUL': false,
    'FAILED': false,
    'CANCELLED': false,
  };
  final Map<String, List<Challenge>> challengesByStatus = {
    "PENDING": [],
    "ACCEPTED": [],
    "REJECTED": [],
    "SUCCESSFUL": [],
    "FAILED": [],
    "CANCELLED": [],
  };

  @override
  Widget build(BuildContext context) {
    return ChallengesPanel(
      key: ValueKey(widget.isAuthor),
      expandedStates: _expandedStates,
      isAuthor: widget.isAuthor,
    );
  }
}
