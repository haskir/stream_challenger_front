import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "localhost";
  Future<Uri?> __getAuthUrl(BuildContext context) async {
    try {
      Uri url = Uri.http(baseUrl, '/auth/');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final redirectUri = response.headers['location'];
        if (redirectUri != null) {
          return Uri.parse(redirectUri);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return null;
  }

  Future<dynamic> __getAccessToken(Uri url) async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    }
    return null;
  }

  Future<String?> __authWithToken(String code) async {
    try {
      final response =
          await http.get(Uri.http(baseUrl, '/auth/callback', {'code': code}));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['access_token'];
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> loginWithTwitch(BuildContext context) async {
    Uri? redirectUrl = await __getAuthUrl(context);
    if (redirectUrl == null) return;
    dynamic code = await __getAccessToken(redirectUrl);
    print("Code: $code");
    if (code == null) return;
    String? token = await __authWithToken(code);
    print("Token: $token");
    if (token == null) return;
    // Все успешно, можно сохранить токен и переходить на главную страницу
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twitch Auth Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthPage(), // Указываем главную страницу приложения
    );
  }
}

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Twitch Auth Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            authService.loginWithTwitch(context);
          },
          child: const Text('Login with Twitch'),
        ),
      ),
    );
  }
}
