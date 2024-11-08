import 'dart:html' as html;
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:stream_challenge/core/token_repo.dart';

import 'platform/auth_state.dart';

abstract class AuthClient {
  Future<void> auth(BuildContext context);
  Future<String?> getToken();
  Future<AuthToken?> getUserInfo();
}

class AuthServiceHTML implements AuthClient {
  final Uri authUrl = Uri.parse('http://localhost:80/api/auth');
  final TokenRepo _tokenRepo = TokenRepo();

  @override
  Future<void> auth(BuildContext context) async {
    final newWindow = html.window.open(authUrl.toString(), "_blank");
    html.window.addEventListener('message', (event) {
      if (event is html.MessageEvent && event.origin == authUrl.origin) {
        if (kDebugMode) {
          String token = event.data;
          print("token: `$token`");
        }
        _tokenRepo.setToken(event.data);
        newWindow.close();
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
  Future<String?> getToken() async {
    return await _tokenRepo.getToken();
  }
}

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  final AuthServiceHTML authService = AuthServiceHTML();
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    setState(() async {
      _token = await authService.getToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              await authService.auth(context);
              _loadToken();
            },
            child: const Text('Авторизация через Twitch'),
          ),
          const SizedBox(height: 20),
          Text(_token != null ? 'Токен: $_token' : 'Токен не получен'),
        ],
      ),
    );
  }
}
