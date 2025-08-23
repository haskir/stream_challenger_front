// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stream_challenge/core/platform/dio.dart';
import 'package:stream_challenge/core/platform/response.dart';
import 'package:stream_challenge/models/transaction.dart';
import 'package:stream_challenge/providers/providers.dart';

class GetStruct {
  final List<String> statuses;
  final int page;
  final int size;

  GetStruct({
    required this.page,
    required this.size,
    this.statuses = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'page': page.toString(),
      'size': size.toString(),
      'status': statuses,
    };
  }

  factory GetStruct.fromMap(Map<String, dynamic> map) {
    return GetStruct(
      statuses: map['status'],
      page: map['page'],
      size: map['size'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GetStruct.fromJson(String source) => GetStruct.fromMap(json.decode(source) as Map<String, dynamic>);
}

class _TransactionGetter {
  static Future<Either<ErrorDTO, Transaction>> getTransaction({
    required int id,
    required Requester client,
  }) async {
    final response = await client.get('/transactions/$id');
    return response.fold(
      (left) => Left(left),
      (right) => Right(Transaction.fromMap(right)),
    );
  }

  static Future<Either<ErrorDTO, List<Transaction>>> getTransactions({
    required GetStruct getStruct,
    required Requester client,
  }) async {
    final response = await client.get(
      '/transactions',
      getStruct.toMap(),
    );
    try {
      return response.fold((error) => Left(error), (array) {
        if (array == null) {
          return Right(List<Transaction>.empty());
        }
        final transactions = (array as List<dynamic>).map((e) => Transaction.fromMap(e)).toList();

        return Right(transactions);
      });
    } catch (e) {
      return Left(ErrorDTO(message: "Error fetching transactions: $e", type: "clientError", code: -500));
    }
  }
}

final transactionProvider = FutureProvider.family<Either<ErrorDTO, Transaction>, int>((ref, id) async {
  final client = await ref.watch(httpClientProvider.future);
  final result = await _TransactionGetter.getTransaction(id: id, client: client);
  return result;
});

final transactionsProvider = FutureProvider.family<List<Transaction>?, GetStruct>((ref, getStruct) async {
  try {
    final result = await _TransactionGetter.getTransactions(
      getStruct: getStruct,
      client: await ref.watch(httpClientProvider.future),
    );
    return result.fold(
      (error) {
        if (kDebugMode) print("transactionsProvider error0: $error");
        return null;
      },
      (transactions) => transactions,
    );
  } catch (error) {
    print("transactionsProvider error1: $error");
    return null;
  }
});
