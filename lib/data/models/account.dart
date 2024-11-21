// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

import 'package:stream_challenge/core/platform/datetime_format.dart';

class Account {
  final int id;
  final int user_id;
  double balance;
  String currency;
  Account({
    required this.id,
    required this.user_id,
    required this.balance,
    required this.currency,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user_id': user_id,
      'balance': balance,
      'currency': currency,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'] as int,
      user_id: map['user_id'] as int,
      balance: map['balance'] as double,
      currency: map['currency'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => prettyJson(toMap());

  factory Account.defaultAccount() => Account(
        balance: 0,
        currency: 'USD',
        id: 0,
        user_id: 0,
      );
}
