import 'package:stream_challenge/data/models/user_preferences.dart';

class AuthToken {
  final int id;
  final String login;
  final String profileImageUrl;
  final String displayName;
  final String email;
  final DateTime expiresAt;
  final Preferences preferences;
  final Account account;

  AuthToken({
    required this.id,
    required this.login,
    required this.profileImageUrl,
    required this.displayName,
    required this.email,
    required this.expiresAt,
    required this.preferences,
    required this.account,
  });

  // Метод для создания экземпляра User из JSON-ответа
  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
      id: json['id'],
      login: json['login'],
      profileImageUrl: json['profile_image_url'],
      displayName: json['display_name'],
      email: json['email'],
      expiresAt: DateTime.fromMillisecondsSinceEpoch(
          json['expires_at'].toInt() * 1000),
      preferences: Preferences.fromJson(json['preferences']),
      account: Account.fromJson(json['account']),
    );
  }

  @override
  String toString() {
    return 'AuthToken{'
        '\nid: $id,\n login: $login,'
        '\n profileImageUrl: $profileImageUrl,\n displayName: $displayName,'
        '\n email: $email,\n expiresAt: $expiresAt,'
        '\n preferences: $preferences,\n account: $account\n'
        '}';
  }
}

class AuthState {
  final AuthToken? user;
  final String? errorMessage;

  AuthState({
    this.user,
    this.errorMessage,
  });

  factory AuthState.authenticated(AuthToken user) {
    return AuthState(user: user);
  }

  factory AuthState.unauthenticated() {
    return AuthState();
  }

  bool get isAuthenticated => user != null;
}
