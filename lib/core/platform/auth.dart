import 'dart:async';

import 'auth_state.dart';

class Auth {
  final StreamController<AuthState> _authStateController =
      StreamController<AuthState>();

  Stream<AuthState> get authState => _authStateController.stream;

  Auth() {
    _authStateController.add(AuthState.unauthenticated());
  }

  // Метод для авторизации пользователя
  Future<void> login(String username, String password) async {
    _authStateController.add(AuthState.loading());

    try {
      throw UnimplementedError();
    } catch (e) {
      _authStateController.add(AuthState.error(e.toString()));
    }
  }

  void logout() {
    _authStateController.add(AuthState.unauthenticated());
  }

  void dispose() {
    _authStateController.close();
  }
}
