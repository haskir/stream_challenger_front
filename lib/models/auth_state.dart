// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:stream_challenge/core/platform/datetime_format.dart';

class AuthedUser {
  final int id;
  final String login;
  final String profile_image_url;
  final String email;
  final String broadcasterType;
  final DateTime exp;

  AuthedUser({
    required this.id,
    required this.login,
    required this.profile_image_url,
    required this.email,
    required this.broadcasterType,
    required this.exp,
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
      'expires_at': exp.millisecondsSinceEpoch,
    };
  }

  factory AuthedUser.fromMap(Map<String, dynamic> map) {
    return AuthedUser(
      id: map['id'] as int,
      login: map['login'],
      profile_image_url: map['profile_image_url'],
      email: map['email'],
      broadcasterType: map['broadcaster_type'],
      exp: DateTime.fromMillisecondsSinceEpoch(
        double.parse(map['expires_at'].toString()).toInt(),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthedUser.fromJson(String source) => AuthedUser.fromMap(json.decode(source) as Map<String, dynamic>);
}

class AuthState {
  final AuthedUser? user;

  AuthState({this.user});

  factory AuthState.authenticated(AuthedUser user) {
    return AuthState(user: user);
  }

  factory AuthState.unauthenticated() {
    return AuthState();
  }

  bool get isAuthenticated => user != null;
}
