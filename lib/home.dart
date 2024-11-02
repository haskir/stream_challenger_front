import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cookie_jar/cookie_jar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FastAPI Frontend',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _client = http.Client();
  final _cookieJar = CookieJar();

  Future<void> _login() async {
    try {
      final response = await _client.get(Uri.parse('http://api.localhost:80/auth'));

      if (response.statusCode == 302) {
        final cookies = response.headers['set-cookie'];
        if (cookies != null) {
          await _cookieJar.saveFromResponse(Uri.parse(response.headers['location']!),
              json.decode(response.body)
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ошибка авторизации')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка сервера')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FastAPI Frontend'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _login,
          child: const Text('Авторизоваться'),
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchProfileData();
  }

  Future<Map<String, dynamic>> _fetchProfileData() async {
    try {
      final response = await http.get(Uri.parse('http://api.localhost:80/profile'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Ошибка сервера');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final profileData = snapshot.data!;
            return ListView(
              children: [
                ListTile(title: Text('ID: ${profileData['id']}')),
                ListTile(title: Text('Логин: ${profileData['login']}')),
                ListTile(title: Text('URL изображения профиля: ${profileData['profile_image_url']}')),
                ListTile(title: Text('Отображаемое имя: ${profileData['display_name']}')),
                ListTile(title: Text('Email: ${profileData['email']}')),
                ListTile(title: Text('Дата истечения токена: ${DateTime.fromMillisecondsSinceEpoch((profileData['expires_at'] * 1000).toInt())}')),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
