import 'package:dartz/dartz.dart';
import 'package:stream_challenge/core/platform/export.dart';

class TransactionsUseCase {
  static Future deposit(transaction, client) async {
    final Either result = await client.post(
      "/transactions/deposit",
      body: transaction.toMap(),
    );
    result.fold(
      (left) => null,
      (right) => Web.openUrl(right["url"]),
    );
  }

  static Future withdraw(transaction, client) async {
    final Either result = await client.post(
      "/transactions/withdraw",
      body: transaction.toMap(),
    );
    result.fold(
      (left) => null,
      (right) => Web.openUrl(right["url"]),
    );
  }
}
