// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:stream_challenge/core/platform/datetime_format.dart';

class CreateTransactionDTO {
  final double amount;
  final String currency;
  final bool isDeposit;

  CreateTransactionDTO({
    required this.amount,
    required this.currency,
    required this.isDeposit,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'amount': amount,
      'currency': currency,
      'is_deposit': isDeposit,
    };
  }

  factory CreateTransactionDTO.fromMap(Map<String, dynamic> map) {
    return CreateTransactionDTO(
      amount: map['amount'] as double,
      currency: map['currency'] as String,
      isDeposit: map['is_deposit'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => prettyJson(toMap());

  factory CreateTransactionDTO.fromJson(String source) =>
      CreateTransactionDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Transaction {
  final String id;
  final String currency;
  final String amount;
  final String comment;
  final String type;
  final DateTime createdAt;
  final String status;

  Transaction({
    required this.id,
    required this.currency,
    required this.amount,
    required this.comment,
    required this.type,
    required this.createdAt,
    required this.status,
  });
}
