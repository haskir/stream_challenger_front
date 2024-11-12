import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  late ChallengesPanelWebSocket _wsconnection;

  Stream<List<Challenge>>? challengesStream;

  @override
  void initState() {
    super.initState();
    initStream();
  }

  Future<void> initStream() async {
    final authNotifier = ref.read(authStateProvider.notifier);

    _wsconnection = ChallengesPanelWebSocket(token: authNotifier.token);
    await _wsconnection.connect().then((connected) {
      if (connected) {
        setState(() {
          challengesStream = _wsconnection.getChallengesStream();
        });
      } else {
        print('Failed to connect to WebSocket.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (challengesStream == null) {
      return Center(child: CircularProgressIndicator());
    }

    return StreamBuilder<List<Challenge>>(
      stream: challengesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No challenges available'));
        } else {
          final challenges = snapshot.data!;
          return ListView.builder(
            itemCount: challenges.length,
            itemBuilder: (context, index) {
              return ChallengeWidgetWithActions(challenge: challenges[index]);
            },
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
