import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:stream_challenge/core/platform/token_repo.dart';
import 'package:stream_challenge/providers/Api.dart';

import 'auth_state.dart';

abstract class AuthClient {
  Future<void> auth(BuildContext context);
  Future<void> logout();
  AuthState getState();
  AuthToken? getUserInfo();
}

class _AuthServiceHTML implements AuthClient {
  late final Uri authUrl;
  String? _token;
  final TokenRepo _tokenRepo = TokenRepo();

  String? get token => _token;

  Future<void> init() async {
    String path = ApiPath.http;
    authUrl = Uri.parse('$path/api/auth');
    _token = await _tokenRepo.getToken();
    authStateNotifier.value =
        _token == null ? AuthState() : AuthState(user: getUserInfo());
  }

  final ValueNotifier<AuthState> authStateNotifier = ValueNotifier(
    AuthState(),
  );

  @override
  Future<void> auth(BuildContext context) async {
    final authCompleter = Completer<void>();

    final newWindow = html.window.open(authUrl.toString(), "_blank");

    // Функция для обработки сообщения от API
    void messageHandler(html.Event event) async {
      if (event is html.MessageEvent && event.origin == authUrl.origin) {
        _token = event.data;
        await _tokenRepo.setToken(event.data);
        authStateNotifier.value = AuthState(user: getUserInfo());
        newWindow.close();

        authCompleter.complete();
      }
    }

    html.window.addEventListener('message', messageHandler);
    await authCompleter.future;
    html.window.removeEventListener('message', messageHandler);
  }

  @override
  AuthToken? getUserInfo() {
    if (_token == null) return null;
    return AuthToken.fromMap(JwtDecoder.decode(_token!));
  }

  @override
  AuthState getState() {
    AuthToken? token = getUserInfo();
    return token == null ? AuthState() : AuthState(user: token);
  }

  @override
  Future<void> logout() async {
    await _tokenRepo.deleteToken();
    _token = null;
    authStateNotifier.value = AuthState();
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final _AuthServiceHTML _authService = _AuthServiceHTML();

  AuthNotifier() : super(AuthState.unauthenticated()) {
    _initializeAuthState();
  }

  void _initializeAuthState() async {
    await _authService.init();
    state = _authService.getState();
  }

  Future<void> auth(BuildContext context) async {
    await _authService.auth(context);
    state = _authService.getState();
  }

  Future<void> logout() async {
    await _authService.logout();
    state = AuthState.unauthenticated();
  }

  String get token => _authService.token ?? '';

  Future<String> getTokenAsync() async {
    // Ждём, пока токен будет установлен
    while (token.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    return token;
  }
}
