// ignore_for_file: unused_import

import 'package:dartz/dartz.dart';
import 'package:stream_challenge/core/platform/dio.dart';
import 'package:stream_challenge/core/platform/response.dart';
import 'package:stream_challenge/data/models/transaction.dart';

abstract class AbstractTransactionsUseCase {
  //Future<Either<ErrorDTO, List<Map<String, dynamic>>>> getTransactions();
  //Future<Either<ErrorDTO, Map<String, dynamic>>> getTransaction(String id);
  Future<Map?> deposit(CreateTransactionDTO transaction, Requester client);
  Future<Map?> withdraw(CreateTransactionDTO transaction, Requester client);
}

class TransactionsUseCase implements AbstractTransactionsUseCase {
  @override
  Future<Map?> deposit(transaction, client) async {
    final result = await client.post(
      "/transactions/deposit",
      body: transaction.toMap(),
    );
    print(result);
    return null;
  }

  @override
  Future<Map?> withdraw(transaction, client) async {
    final result = await client.post(
      "/transactions/withdraw",
      body: transaction.toMap(),
    );
    print(result);
    return null;
  }
}
