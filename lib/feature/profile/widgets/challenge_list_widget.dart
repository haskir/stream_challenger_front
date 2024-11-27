import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/feature/profile/widgets/challenges_panel_builder.dart';
import 'package:stream_challenge/providers/challenge_provider.dart';

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
    //'ACCEPTED': false,
    'PENDING': false,
    'REJECTED': false,
    //'FAILED': false,
    //'CANCELLED': false,
    //'SUCCESSFUL': false,
  };

  @override
  Widget build(BuildContext context) {
    final challengesProvider = widget.isAuthor
        ? authorChallengesProvider // Провайдер для своих челленджей
        : performerChallengesProvider; // Провайдер для челленджей ко мне
    return ChallengesPanel(
      expandedStates: _expandedStates,
      challengesProvider: challengesProvider,
    );
  }
}
