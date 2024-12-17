import 'dart:async';
import 'dart:html' as html;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:stream_challenge/core/platform/token_repo.dart';
import 'package:stream_challenge/providers/api.dart';

import '../../data/models/auth_state.dart';

abstract class AuthClient {
  Future<void> auth(BuildContext context);
  Future<void> logout();
  AuthState getState();
  AuthedUser? getUserInfo();
}

class _AuthServiceHTML implements AuthClient {
  String path = ApiProvider.http;
  bool _validated = false;
  late final Uri authUrl;
  String? _token;
  final TokenRepo _tokenRepo = TokenRepo();

  String? get token => _token;

  Future<void> init() async {
    authUrl = Uri.parse('${path}auth');
    _token = await _tokenRepo.getToken();
    /* if (!_validated && !kDebugMode) {
      _token = await validate() ? _token : null;
    } */
    authStateNotifier.value =
        _token == null ? AuthState() : AuthState(user: getUserInfo());
  }

  Future<bool> validate() async {
    if (token == null) return false;
    try {
      Dio dio = Dio();
      Response response = await dio.get(
        "${path}auth/validate",
        options: Options(headers: {
          "Authorization": "Bearer $_token",
          "Content-Type": "application/json",
        }),
      );
      _validated = response.statusCode == 200;
      return response.statusCode == 200;
    } catch (e) {
      print("Error validating token: $e");
      return false;
    }
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
  AuthedUser? getUserInfo() {
    if (_token == null) return null;
    return AuthedUser.fromMap(JwtDecoder.decode(_token!));
  }

  @override
  AuthState getState() {
    AuthedUser? token = getUserInfo();
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
