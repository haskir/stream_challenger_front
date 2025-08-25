import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:stream_challenge/models/challenge.dart';
import 'package:stream_challenge/providers/api.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class AbstractChallengePanelRequester {
  Future<bool> connect();
  bool isConnected();
  void disconnect();
  Stream<List<Challenge>> getChallengesStream();
}

class ChallengesPanelWebSocket implements AbstractChallengePanelRequester {
  final String token;
  final Uri wsUrl = Uri.parse('${ApiProvider.ws}panel/');
  late WebSocketChannel _channel;
  bool _isConnected = false;
  final List<Challenge> _challenges = [];
  final StreamController<List<Challenge>> _challengeController = StreamController.broadcast();
  Timer? _pingTimer;
  Timer? _reconnectTimer;

  ChallengesPanelWebSocket({required this.token});

  @override
  Future<bool> connect() async {
    if (kDebugMode) print('Connecting to WebSocket ${wsUrl.toString()} ...');

    _channel = WebSocketChannel.connect(wsUrl);

    try {
      await _channel.ready;
      _channel.sink.add(jsonEncode({"token": token}));
      _channel.stream.listen(
        (data) => _handleData(data),
        onError: (error) => _handleError(error),
        onDone: _handleDisconnect,
      );
      if (kDebugMode) print("WebSocket connected.");
      _channel.sink.add(jsonEncode({"token": token}));
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
      dynamic parsedData = jsonDecode(data);
      print(parsedData);
      if (parsedData is String) parsedData = jsonDecode(parsedData);
      print(parsedData);
      if (parsedData is List) {
        _challenges.clear();
        _challenges.addAll(parsedData.map((json) => Challenge.fromMap(json)));
      }
      if (parsedData is Map) {
        bool isNew = true;
        for (Challenge challenge in _challenges) {
          if (challenge.id == parsedData['id']) {
            challenge.update(parsedData as Map<String, dynamic>);
            isNew = false;
            break;
          }
        }
        if (isNew) {
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

  void _handleError(error) {
    if (kDebugMode) print('WebSocket error: $error');
    disconnect();
    _reconnect();
  }

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
