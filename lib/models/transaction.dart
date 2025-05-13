// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:stream_challenge/core/platform/datetime_format.dart';

class CreateTransactionDTO {
  final double amount;
  final String currency;
  final bool isDeposit;
  final String returnUrl;

  CreateTransactionDTO({
    required this.amount,
    required this.currency,
    required this.isDeposit,
    required this.returnUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'amount': amount,
      'currency': currency,
      'is_deposit': isDeposit,
      'return_url': returnUrl,
    };
  }

  factory CreateTransactionDTO.fromMap(Map<String, dynamic> map) {
    return CreateTransactionDTO(
      amount: map['amount'],
      currency: map['currency'],
      isDeposit: map['is_deposit'],
      returnUrl: map['return_url'],
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
  final double amount;
  final String currency;
  final String type;
  final DateTime createdAt;
  final String status;

  Transaction({
    required this.id,
    required this.currency,
    required this.amount,
    required this.type,
    required this.createdAt,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'amount': amount,
      'currency': currency,
      'type': type,
      'created_at': createdAt.millisecondsSinceEpoch,
      'status': status,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      amount: map['amount'],
      currency: map['currency'],
      type: map['type'],
      createdAt: DateTime.parse(map['created_at']),
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => prettyJson(toMap());
}
