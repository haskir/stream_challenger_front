import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/feature/streamer_panel/web_socket_client.dart';
import 'package:stream_challenge/feature/streamer_panel/widgets/challenges_panel_builder.dart';
import 'package:stream_challenge/providers/providers.dart';

class PanelWidget extends ConsumerStatefulWidget {
  const PanelWidget({super.key});

  @override
  ConsumerState<PanelWidget> createState() => _PanelWidgetState();
}

class _PanelWidgetState extends ConsumerState<PanelWidget> {
  final Map<String, bool> _expandedStates = {
    'ACCEPTED': false,
    'ENDED': false,
    'PENDING': false,
    'REJECTED': false,
    'FAILED': false,
    'HIDDEN': false,
    'SUCCESSFUL': false,
  };

  late ChallengesPanelWebSocket _wsconnection;
  Stream<List<Challenge>>? challengesStream;

  @override
  void initState() {
    super.initState();
    initStream();
  }

  Future<void> initStream() async {
    final authNotifier = ref.read(authStateProvider.notifier);

    _wsconnection =
        ChallengesPanelWebSocket(token: await authNotifier.getTokenAsync());
    await _wsconnection.connect().then((connected) {
      if (connected) {
        setState(() {
          challengesStream = _wsconnection.getChallengesStream();
        });
      } else {
        if (kDebugMode) {
          print('Failed to connect to WebSocket.');
        }
      }
    });
  }

  Map<String, List<Challenge>> _groupChallengesByState(
      List<Challenge> challenges) {
    final Map<String, List<Challenge>> challengesByState = {
      'ACCEPTED': [],
      'PENDING': [],
      'REJECTED': [],
      'SUCCESSFUL': [],
      'FAILED': [],
      'HIDDEN': [],
    };

    for (var challenge in challenges) {
      if (challengesByState[challenge.status] != null) {
        challengesByState[challenge.status] = [
          ...challengesByState[challenge.status]!,
          challenge
        ];
      }
    }

    return challengesByState;
  }

  @override
  Widget build(BuildContext context) {
    if (challengesStream == null) {
      return Center(child: CircularProgressIndicator());
    }

    return StreamBuilder<List<Challenge>>(
      stream: challengesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.hasError) {
          return Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text(
            AppLocalizations.of(context).translate('No challenges available'),
          ));
        } else {
          final challenges = snapshot.data!;
          final challengesByState = _groupChallengesByState(challenges);

          final panelBuilder = ChallengesPanelBuilder(
            expandedStates: _expandedStates,
          );

          return ListView(
            children: [
              ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    final state = challengesByState.keys.elementAt(index);
                    _expandedStates[state] = isExpanded;
                  });
                },
                children: panelBuilder.buildExpansionPanels(
                  context,
                  challengesByState,
                ),
              ),
            ],
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _wsconnection.disconnect();
    super.dispose();
  }
}
