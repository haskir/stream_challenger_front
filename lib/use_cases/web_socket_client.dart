import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/providers/Api.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class AbstractChallengePanelRequester {
  Future<bool> connect();
  bool isConnected();
  void disconnect();
  Stream<List<Challenge>> getChallengesStream();
}

class ChallengesPanelWebSocket implements AbstractChallengePanelRequester {
  final String token;
  final Uri wsUrl = Uri.parse('${ApiPath.ws}panel/');
  late WebSocketChannel _channel;
  bool _isConnected = false;
  final List<Challenge> _challenges = [];
  final StreamController<List<Challenge>> _challengeController =
      StreamController.broadcast();
  Timer? _pingTimer;
  Timer? _reconnectTimer;

  ChallengesPanelWebSocket({required this.token});

  @override
  Future<bool> connect() async {
    if (kDebugMode) print('Connecting to WebSocket...');

    _channel = WebSocketChannel.connect(wsUrl);

    try {
      await _channel.ready;
      _channel.sink.add(jsonEncode({"token": token}));
      _channel.stream.listen(
        (data) => _handleData(data),
        onError: (error) => _handleError(error),
        onDone: _handleDisconnect,
      );
      _startPing();
      if (kDebugMode) print("WebSocket connected.");
      return true;
    } on WebSocketChannelException {
      if (kDebugMode) print('WebSocket connection failed.');
      _isConnected = false;
      _reconnect();
      return false;
    } catch (e) {
      _isConnected = false;
      if (kDebugMode) print('Unexpected error during WebSocket connection: $e');
      return false;
    }
  }

  void _handleData(dynamic data) {
    try {
      if (data == null) return;
      final parsedData = jsonDecode(data);

      if (parsedData is List) {
        // Инициализация списка
        _challenges.clear();
        _challenges.addAll(parsedData.map((json) => Challenge.fromMap(json)));
      } else if (parsedData is Map) {
        bool flag = false;
        for (Challenge challenge in _challenges) {
          if (challenge.id == parsedData['id']) {
            print("OLD: challenge: ${challenge.toString()}");
            challenge.update(parsedData as Map<String, dynamic>);
            print("NEW: challenge: ${challenge.toString()}");
            flag = true;
            break;
          }
        }
        if (!flag) {
          _addChallenge(Challenge.fromMap(parsedData as Map<String, dynamic>));
        }
      }
      // Передаем обновленный список
      _challengeController.add(List.unmodifiable(_challenges));
    } catch (e) {
      if (kDebugMode) print('Error processing WebSocket data: $e');
      disconnect();
      _reconnect();
    }
  }

  void _addChallenge(Challenge challenge) {
    if (!_challenges.any((c) => c.id == challenge.id)) {
      _challenges.add(challenge);
    }
  }

  void _updateChallenge(Challenge challenge) {
    final index = _challenges.indexWhere((c) => c.id == challenge.id);
    if (index != -1) {
      _challenges[index] = challenge;
    }
  }

  void _handleError(error) => _reconnect();

  void _handleDisconnect() {
    _challengeController.sink.addError('Connection lost.');
    _isConnected = false;
    _reconnect();
  }

  void _startPing() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      try {
        _channel.sink.add(jsonEncode({"type": "ping"}));
      } catch (e) {
        _reconnect();
      }
    });
  }

  void _reconnect() {
    if (_reconnectTimer != null && _reconnectTimer!.isActive) return;

    _isConnected = false;
    _reconnectTimer = Timer(const Duration(seconds: 5), () async {
      await connect();
    });
  }

  @override
  bool isConnected() => _isConnected;

  @override
  void disconnect() {
    _channel.sink.close();
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _challengeController.close();
    _isConnected = false;
  }

  @override
  Stream<List<Challenge>> getChallengesStream() => _challengeController.stream;
}
