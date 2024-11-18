import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/providers.dart';

import '../web_socket_client.dart';
import 'challenge_widget.dart';

class PanelWidget extends ConsumerStatefulWidget {
  const PanelWidget({super.key});

  static const Map<String, String> headers = {
    'ACCEPTED': "Accepted Challenges",
    "ENDED": "Waiting for voting",
    'PENDING': "New Challenges",
    'REJECTED': "Rejected Challenges",
    'FAILED': "Failed Challenges",
    'HIDDEN': "Hidden Challenges",
    'SUCCESSFUL': "Successful Challenges",
  };

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
  static const Map<String, Color> _colors = {
    'ACCEPTED': Colors.blue,
    'ENDED': Colors.yellow,
    'PENDING': Colors.orange,
    'REJECTED': Colors.red,
    'FAILED': Colors.black,
    'HIDDEN': Colors.grey,
    'SUCCESSFUL': Colors.green,
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
            title: Text(AppLocalizations.of(context)
                .translate(PanelWidget.headers[state]!)),
            trailing: Text('(${challenges.length})',
                style: TextStyle(
                  color: _colors[state],
                  fontSize: 18,
                )),
          );
        },
        body: Column(
            children: challenges
                .map((challenge) =>
                    ChallengeWidgetWithActions(challenge: challenge))
                .toList()),
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
          return Center(
              child: Text(
            AppLocalizations.of(context).translate('No challenges available'),
          ));
        } else {
          final challenges = snapshot.data!;
          final challengesByState = _groupChallengesByState(challenges);

          return ListView(
            children: [
              ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    final state = challengesByState.keys.elementAt(index);
                    _expandedStates[state] = isExpanded;
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
      'PENDING': [],
      'REJECTED': [],
      'SUCCESSFUL': [],
      'FAILED': [],
      'HIDDEN': [],
    };

    for (var challenge in challenges) {
      if (challenge.status == 'ENDED') {
        challengesByState['ACCEPTED']?.add(challenge);
      }
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
