import 'dart:convert';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/providers.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class AbstractChallengeRequester {
  Future<void> acceptChallenge(Challenge challenge);
  Future<void> rejectChallenge(Challenge challenge);
  Future<void> reportChallenge(Challenge challenge);
  Future<void> endChallenge(Challenge challenge);
}

abstract class AbstractChallengePanelRequester {
  Future<bool> connect();
  Future<bool> isConnected();
  Future<void> disconnect();
  Stream<List<Challenge>> getChallengesStream();
}

class ChallengesActions implements AbstractChallengeRequester {
  @override
  Future<void> acceptChallenge(Challenge challenge) async {}

  @override
  Future<void> rejectChallenge(Challenge challenge) async {}

  @override
  Future<void> reportChallenge(Challenge challenge) async {}

  @override
  Future<void> endChallenge(Challenge challenge) async {}
}

class ChallengesPanelWebSocket implements AbstractChallengePanelRequester {
  final String token;
  final Uri wsUrl = Uri.parse('${ApiPath.ws}/panel/ws');
  late WebSocketChannel _channel;
  bool _isConnected = false;

  ChallengesPanelWebSocket({required this.token});

  @override
  Future<bool> connect() async {
    try {
      _channel = WebSocketChannel.connect(
        wsUrl,
      );
      _channel.sink.add('{"token": "$token"}');
      _isConnected = true;
      return true;
    } catch (e) {
      _isConnected = false;
      print('Error connecting to WebSocket: $e');
      return false;
    }
  }

  @override
  Future<bool> isConnected() async {
    return _isConnected;
  }

  @override
  Future<void> disconnect() async {
    try {
      await _channel.sink.close();
      _isConnected = false;
    } catch (e) {
      print('Error disconnecting: $e');
    }
  }

  @override
  Stream<List<Challenge>> getChallengesStream() {
    return _channel.stream.map((data) {
      try {
        final challengesJson = jsonDecode(data) as List;
        return challengesJson.map((json) => Challenge.fromJson(json)).toList();
      } catch (e) {
        print('Error parsing challenges: $e');
        return <Challenge>[];
      }
    });
  }

  List<Challenge> test() {
    return [
      Challenge.testAccepted(),
      Challenge.testPending(),
      Challenge.testRejected(),
      Challenge.testReported(),
    ];
  }
}
