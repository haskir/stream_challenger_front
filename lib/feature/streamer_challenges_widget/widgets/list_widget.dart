import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/core/platform/datetime_format.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/providers.dart';

import '../web_socket_client.dart';
import 'challenge_widget.dart';

class PanelWidget extends ConsumerStatefulWidget {
  const PanelWidget({super.key});

  @override
  ConsumerState<PanelWidget> createState() => _PanelWidgetState();
}

class _PanelWidgetState extends ConsumerState<PanelWidget> {
  final Map<String, bool> _expandedStates = {
    'ACCEPTED': false,
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

  List<ExpansionPanel> _buildExpansionPanels(
      Map<String, List<Challenge>> challengesByState) {
    return challengesByState.entries.map((entry) {
      final state = entry.key;
      final challenges = entry.value;

      return ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) {
          return ListTile(
            title: Text('$state (${challenges.length})'),
          );
        },
        body: Column(
          children: challenges
              .map((challenge) =>
                  ChallengeWidgetWithActions(challenge: challenge))
              .toList(),
        ),
        isExpanded: _expandedStates[state]!,
        canTapOnHeader: true,
      );
    }).toList();
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
          return Center(child: Text('No challenges available'));
        } else {
          final challenges = snapshot.data!;
          final challengesByState = _groupChallengesByState(challenges);

          return ListView(
            children: [
              ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    final state = challengesByState.keys.elementAt(index);
                    if (challengesByState[state]!.isNotEmpty) {
                      _expandedStates[state] = isExpanded;
                    }
                  });
                },
                children: _buildExpansionPanels(challengesByState),
              ),
            ],
          );
        }
      },
    );
  }

  Map<String, List<Challenge>> _groupChallengesByState(
      List<Challenge> challenges) {
    final Map<String, List<Challenge>> challengesByState = {
      'ACCEPTED': [],
      'REJECTED': [],
      'PENDING': [],
      'SUCCESSFUL': [],
      'FAILED': [],
      'HIDDEN': [],
    };

    for (var challenge in challenges) {
      challengesByState[challenge.status]?.add(challenge);
    }
    return challengesByState;
  }

  @override
  void dispose() {
    _wsconnection.disconnect();
    super.dispose();
  }
}
