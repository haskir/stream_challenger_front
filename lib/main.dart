import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stream_challenger_front/theme.dart';

void main() => runApp(const SignUpApp());

class SignUpApp extends StatelessWidget {
  const SignUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: darkTheme,
      routes: {
        '/': (context) => const ChallengeListWidget(),
        '/welcome': (context) => const WelcomeScreen(),
      },
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Welcome!',
        ),
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: const Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: SignUpForm(),
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _usernameTextController = TextEditingController();

  late double _formProgress = 0;

  void _showWelcomeScreen() {
    Navigator.of(context).pushNamed('/welcome');
  }

  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      _firstNameTextController,
      _lastNameTextController,
      _usernameTextController
    ];

    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }

    setState(() {
      _formProgress = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: _formProgress),
          Text('Sign up', style: Theme.of(context).textTheme.headlineMedium),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _firstNameTextController,
              decoration: const InputDecoration(hintText: 'First name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _lastNameTextController,
              decoration: const InputDecoration(hintText: 'Last name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _usernameTextController,
              decoration: const InputDecoration(hintText: 'Username'),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                return states.contains(WidgetState.disabled)
                    ? null
                    : Colors.white;
              }),
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                return states.contains(WidgetState.disabled)
                    ? null
                    : Colors.blue;
              }),
            ),
            onPressed:
                _formProgress == 1 ? _showWelcomeScreen : null, // UPDATED
            child: const Text('Sign up'),
          ),
        ],
      ),
    );
  }
}

class ChallengeListWidget extends StatefulWidget {
  const ChallengeListWidget({super.key});

  @override
  State<StatefulWidget> createState() => _ChallengeListWidgetState();
}

class _ChallengeListWidgetState extends State<ChallengeListWidget> {
  List<dynamic> challenges = [];

  @override
  void initState() {
    super.initState();
    // Здесь вы можете заменить JSON-строку на ваш источник данных
    String jsonString = '''
    [
      {"title": "Вызов 1", "description": "Описание вызова 1"},
      {"title": "Вызов 2", "description": "Описание вызова 2"},
      {"title": "Вызов 3", "description": "Описание вызова 3"}
    ]
    ''';
    challenges = json.decode(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        return ChallengeWidget(
          title: challenges[index]['title'],
          description: challenges[index]['description'],
        );
      },
    );
  }
}

class ChallengeWidget extends StatelessWidget {
  final String title;
  final String description;

  const ChallengeWidget({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(description),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () => _doAccept(), child: const Text("Принять")),
              TextButton(onPressed: () => _doDecline(), child: const Text("Отклонить")),
              TextButton(onPressed: () => _doReport(), child: const Text("Пожаловаться")),
            ],
          ),
        ],
      ),
    );
  }

  void _doAccept() {
    print("$title принят");
  }

  void _doDecline() {
    print("$title отклонён");
  }

  void _doReport() {
    print("Пожаловаться на $title");
  }
}
