// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:stream_challenge/core/platform/datetime_format.dart';

class AuthToken {
  final int id;
  final String login;
  final String profile_image_url;
  final String email;
  final String broadcasterType;
  final DateTime expires_at;
  final int account_id;
  final int preferences_id;

  AuthToken({
    required this.id,
    required this.login,
    required this.profile_image_url,
    required this.email,
    required this.broadcasterType,
    required this.expires_at,
    required this.account_id,
    required this.preferences_id,
  });

  @override
  String toString() => prettyJson(toMap());

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'login': login,
      'profile_image_url': profile_image_url,
      'email': email,
      'broadcaster_type': broadcasterType,
      'expires_at': expires_at.millisecondsSinceEpoch,
      'account_id': account_id,
      'preferences_id': preferences_id,
    };
  }

  factory AuthToken.fromMap(Map<String, dynamic> map) {
    return AuthToken(
      id: map['id'] as int,
      login: map['login'],
      profile_image_url: map['profile_image_url'],
      email: map['email'],
      broadcasterType: map['broadcaster_type'],
      expires_at: DateTime.fromMillisecondsSinceEpoch(
        double.parse(map['expires_at'].toString()).toInt(),
      ),
      account_id: map['account_id'],
      preferences_id: map['preferences_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthToken.fromJson(String source) =>
      AuthToken.fromMap(json.decode(source) as Map<String, dynamic>);
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
