// ignore_for_file: non_constant_identifier_names

import 'account.dart';

class User {
  final String id;
  final String description;
  final String broadcaster_type;
  final String view_count;
  final String login;
  final String display_name;
  final String profile_image_url;
  final String email;
  final String is_administrator;
  final String user_status;
  final Account account;
  final UserPreferences userPreferences;

  User({
    required this.id,
    required this.description,
    required this.broadcaster_type,
    required this.view_count,
    required this.login,
    required this.display_name,
    required this.profile_image_url,
    required this.email,
    required this.is_administrator,
    required this.user_status,
    required this.account,
    required this.userPreferences,
  });

  // From JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      description: json['description'],
      broadcaster_type: json['broadcaster_type'],
      view_count: json['view_count'],
      login: json['login'],
      display_name: json['display_name'],
      profile_image_url: json['profile_image_url'],
      email: json['email'],
      is_administrator: json['is_administrator'],
      user_status: json['user_status'],
      account: Account.fromJson(json['account']),
      userPreferences: UserPreferences.fromJson(json['userPreferences']),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'broadcaster_type': broadcaster_type,
      'view_count': view_count,
      'login': login,
      'display_name': display_name,
      'profile_image_url': profile_image_url,
      'email': email,
      'is_administrator': is_administrator,
      'user_status': user_status,
      'account': account.toJson(),
      'userPreferences': userPreferences.toJson(),
    };
  }
}
