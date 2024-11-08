import 'dart:html' as html; // Для работы с localStorage
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthService {
  final Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:81/api/auth'));

  Future<void> authorizeUser(BuildContext context) async {
    final Uri authUrl = Uri.parse('${dio.options.baseUrl}/auth');

    // Открываем ссылку авторизации в новом окне
    if (await canLaunchUrl(authUrl)) {
      await launchUrl(authUrl, webOnlyWindowName: "_blank");
    } else {
      throw 'Could not launch $authUrl';
    }

    // Устанавливаем прослушивание для получения токена после авторизации
    _listenForCallback(context);
  }

  void _listenForCallback(BuildContext context) {
    html.window.onMessage.listen((event) {
      if (event.data != null && event.data.contains('token=')) {
        final token = Uri.parse(event.data).queryParameters['token'];
        if (token != null) {
          html.window.localStorage['jwt'] = token;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SuccessScreen()),
          );
        }
      }
    });
  }
}

class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Успешная авторизация")),
      body: Center(
        child: Text("Вы успешно авторизовались в приложении!"),
      ),
    );
  }
}
