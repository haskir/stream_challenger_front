import 'package:flutter/material.dart';
import 'package:stream_challenge/core/platform/auth.dart';
import 'package:stream_challenge/core/platform/auth_state.dart';

class AuthWidget extends StatelessWidget {
  final Auth auth;

  const AuthWidget({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: auth.authState,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final authState = snapshot.data!;

        switch (authState.status) {
          case AuthStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case AuthStatus.authenticated:
            return Center(
              child: Column(
                children: [
                  Text('Добро пожаловать, ${authState.user?.displayName}'),
                  Image.network(
                      authState.user!.profileImageUrl), // Отображение аватарки
                  ElevatedButton(
                    onPressed: auth.logout,
                    child: const Text('Выйти'),
                  ),
                ],
              ),
            );
          case AuthStatus.unauthenticated:
            return Center(
                child: TextButton(
              child: const Text("Авторизоваться"),
              onPressed: () {},
            ));
          // return LoginForm(auth: auth);
          case AuthStatus.error:
            return Center(child: Text('Ошибка: ${authState.errorMessage}'));
        }
      },
    );
  }
}
