import 'dart:html' as html;
import 'dart:async';
import 'package:flutter/material.dart';

class AuthService {
  AuthService() {
    _initLocalStorageListener();
  }

  Future<void> authorizeUser(BuildContext context) async {
    final Uri authUrl = Uri.parse('http://localhost:80/api/auth');
    final newWindow = html.window.open(authUrl.toString(), "_blank");

    // Слушаем сообщения от открытого окна
    html.window.addEventListener('message', (event) {
      if (event is html.MessageEvent && event.origin == authUrl.origin) {
        _handleToken(event.data);
        newWindow.close();
      }
    });
  }

  void _initLocalStorageListener() {
    html.window.addEventListener('storage', (event) {
      if (event is html.StorageEvent &&
          event.storageArea == html.window.localStorage &&
          event.key == 'jwt' &&
          event.newValue != null) {
        _handleToken(event.newValue!);
      }
    });
  }

  void _handleToken(String token) {
    html.window.localStorage['jwt'] = token;
  }

  Future<String?> getToken() async {
    return html.window.localStorage['jwt'];
  }
}

class AuthWidget extends StatefulWidget {
  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  final AuthService authService = AuthService();
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
              await authService.authorizeUser(context);
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
