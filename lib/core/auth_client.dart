// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:stream_challenge/core/token_repo.dart';

import 'platform/auth_state.dart';

abstract class AuthClient {
  Future<void> auth(BuildContext context);
  Future<void> logout();
  Future<AuthState> getState();
  AuthToken? getUserInfo();
}

class AuthServiceHTML implements AuthClient {
  final Uri authUrl = Uri.parse('http://localhost:80/api/auth');
  String? _token;
  final TokenRepo _tokenRepo = TokenRepo();

  // Создаем ValueNotifier для отслеживания состояния авторизации
  final ValueNotifier<AuthState> authStateNotifier = ValueNotifier(
    AuthState(status: AuthStatus.unauthenticated),
  );

  @override
  Future<void> auth(BuildContext context) async {
    final newWindow = html.window.open(authUrl.toString(), "_blank");

    html.window.addEventListener('message', (event) async {
      if (event is html.MessageEvent && event.origin == authUrl.origin) {
        if (kDebugMode) {
          String token = event.data;
          print("token: `$token`");
        }
        _token = event.data;
        await _tokenRepo.setToken(event.data);
        newWindow.close();

        AuthToken? user = getUserInfo();
        authStateNotifier.value = user == null
            ? AuthState(status: AuthStatus.unauthenticated)
            : AuthState(status: AuthStatus.authenticated, user: user);
      }
    });
  }

  @override
  AuthToken? getUserInfo() {
    if (_token == null) return null;
    return AuthToken.fromJson(JwtDecoder.decode(_token!));
  }

  @override
  Future<AuthState> getState() async {
    AuthToken? token = getUserInfo();
    return token == null
        ? AuthState(status: AuthStatus.unauthenticated)
        : AuthState(status: AuthStatus.authenticated, user: token);
  }

  @override
  Future<void> logout() async {
    await _tokenRepo.deleteToken();
    authStateNotifier.value = AuthState(status: AuthStatus.unauthenticated);
  }
}
