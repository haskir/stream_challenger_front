// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:stream_challenge/core/platform/datetime_format.dart';

// ignore_for_file: non_constant_identifier_names

class Account {
  final double balance;
  final String currency;

  Account({required this.balance, required this.currency});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'balance': balance,
      'currency': currency,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      balance: map['balance'] as double,
      currency: map['currency'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => prettyJson(toMap());

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Preferences {
  final double minimum_reward_in_dollars;
  final String language;
  final String timezone;

  Preferences({
    required this.minimum_reward_in_dollars,
    required this.language,
    required this.timezone,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'minimum_reward_in_dollars': minimum_reward_in_dollars,
      'language': language,
      'timezone': timezone,
    };
  }

  factory Preferences.fromMap(Map<String, dynamic> map) {
    return Preferences(
      minimum_reward_in_dollars: map['minimum_reward_in_dollars'] as double,
      language: map['language'] as String,
      timezone: map['timezone'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => prettyJson(toMap());

  factory Preferences.fromJson(String source) =>
      Preferences.fromMap(json.decode(source) as Map<String, dynamic>);
}
