import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/core/platform/auth_state.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/providers.dart';

import 'challenge_widget.dart';

class PanelWidget extends ConsumerStatefulWidget {
  const PanelWidget({super.key});

  @override
  ConsumerState<PanelWidget> createState() => _PanelWidgetState();
}

class _PanelWidgetState extends ConsumerState<PanelWidget> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final List<Challenge> challenges = [];

    if (!authState.isAuthenticated) {
      return Center(
        child: Text(
          AppLocalizations.of(context).translate("Please log in"),
        ),
      );
    }

    if (challenges.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context).translate("No challenges."),
        ),
      );
    }

    return ListView.builder(
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        final challenge = challenges[index];
        return ChallengeWidget(
          challenge: challenge,
        );
      },
    );
  }
}
