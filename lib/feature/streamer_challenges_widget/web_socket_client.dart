import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/providers.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class AbstractChallengePanelRequester {
  Future<bool> connect();
  bool isConnected();
  void disconnect();
  Stream<List<Challenge>> getChallengesStream();
}

class ChallengesPanelWebSocket implements AbstractChallengePanelRequester {
  final String token;
  final Uri wsUrl = Uri.parse('${ApiPath.ws}/panel/ws');
  late WebSocketChannel _channel;
  bool _isConnected = false;
  final StreamController<List<Challenge>> _challengeController =
      StreamController.broadcast();
  Timer? _pingTimer;
  Timer? _reconnectTimer;

  ChallengesPanelWebSocket({required this.token});

  @override
  Future<bool> connect() async {
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
      return true;
    } on WebSocketChannelException catch (e) {
      _isConnected = false;
      _reconnect();
      return false;
    } catch (e) {
      _isConnected = false;
      if (kDebugMode) {
        print('Unexpected error during WebSocket connection: $e');
      }
      return false;
    }
  }

  // Обработка входящих данных
  void _handleData(dynamic data) {
    try {
      final challengesJson = jsonDecode(data) as List;
      final challenges =
          challengesJson.map((json) => Challenge.fromJson(json)).toList();
      _challengeController.add(challenges);
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing challenges: $e');
      }
    }
  }

  // Обработка ошибок соединения
  void _handleError(error) => _reconnect();

  // Обработка завершения соединения
  void _handleDisconnect() {
    _challengeController.sink.addError('Connection lost.');
    _isConnected = false;
    _reconnect();
  }

  // Пинг для поддержания соединения
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

  // Автопереподключение
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
