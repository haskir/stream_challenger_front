import 'dart:convert';
import 'package:stream_challenge/core/platform/datetime_format.dart';

class Account {
  final int id;
  final int userId;
  double balance;
  String currency;
  Account({
    required this.id,
    required this.userId,
    required this.balance,
    required this.currency,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user_id': userId,
      'balance': balance,
      'currency': currency,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'] as int,
      userId: map['user_id'] as int,
      balance: map['balance'] as double,
      currency: map['currency'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  static const double epsilon = 1e-9; // Допустимая погрешность
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is Account &&
        other.id == id &&
        other.userId == userId &&
        other.balance == balance &&
        other.currency == currency;
  }

  @override
  int get hashCode =>
      id.hashCode ^ userId.hashCode ^ balance.hashCode ^ currency.hashCode;

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => prettyJson(toMap());

  factory Account.defaultAccount() => Account(
        balance: 0,
        currency: 'USD',
        id: 0,
        userId: 0,
      );
}
