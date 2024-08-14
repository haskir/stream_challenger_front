import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Challenge Site',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: MyChallengesPage(),
        ),
      ),
    );
  }
}

class MyChallengesPage extends StatelessWidget {
  const MyChallengesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [TopNavBar()],
    );
  }
}

class TopNavBar extends StatelessWidget {
  const TopNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // "Мои Челленджи" кнопка
          TextButton(
            onPressed: () => print("Мои челенджи"),
            child: const Text(
              "Мои челленджи",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          const SizedBox(width: 40),

          TextButton(
            onPressed: () => print("Игры"),
            child: const Text(
              "Игры",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          const SizedBox(width: 40),

          TextButton(
            onPressed: () => print("Топ челленджи"),
            child: const Text(
              "Топ челленджи",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          const SizedBox(width: 40),

          // Профиль в виде отдельного виджета
          Container(
            alignment: Alignment.topRight,
            child: const ProfileWidget(authorizedUser: false),
          )
        ],
      ),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  final bool authorizedUser;

  const ProfileWidget({super.key, required this.authorizedUser});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 37.5, // Радиус для 75x75 картинки
          backgroundImage: authorizedUser
              ? const NetworkImage(
                  'https://via.placeholder.com/150') // Ваша картинка
              : null,
          backgroundColor: authorizedUser ? Colors.transparent : Colors.grey,
          child: !authorizedUser
              ? const Icon(Icons.person, size: 40, color: Colors.white)
              : null,
        ),
        const SizedBox(width: 10),
        TextButton(
          onPressed: () => print("Профиль"),
          child: Text(
            authorizedUser ? 'Профиль' : 'Авторизоваться',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ],
    );
  }
}
