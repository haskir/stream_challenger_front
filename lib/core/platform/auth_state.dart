class AuthToken {
  final int id;
  final String login;
  final String profileImageUrl;
  final String displayName;
  final String email;
  final DateTime expiresAt;

  AuthToken({
    required this.id,
    required this.login,
    required this.profileImageUrl,
    required this.displayName,
    required this.email,
    required this.expiresAt,
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
    );
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
