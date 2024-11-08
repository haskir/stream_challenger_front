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
  Future<AuthToken?> getUserInfo();
}

class AuthServiceHTML implements AuthClient {
  final Uri authUrl = Uri.parse('http://localhost:80/api/auth');
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
        await _tokenRepo.setToken(event.data);
        newWindow.close();

        // Обновляем состояние авторизации после получения токена
        AuthToken? user = await getUserInfo();
        authStateNotifier.value = user == null
            ? AuthState(status: AuthStatus.unauthenticated)
            : AuthState(status: AuthStatus.authenticated, user: user);
      }
    });
  }

  @override
  Future<AuthToken?> getUserInfo() async {
    String? token = await _tokenRepo.getToken();
    if (token == null) {
      return null;
    }
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    return AuthToken.fromJson(decodedToken);
  }

  @override
  Future<AuthState> getState() async {
    AuthToken? token = await getUserInfo();
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
