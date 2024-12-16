// ignore_for_file: unused_import

import 'package:dartz/dartz.dart';
import 'package:stream_challenge/core/platform/dio.dart';
import 'package:stream_challenge/core/platform/response.dart';
import 'package:stream_challenge/data/models/transaction.dart';
import 'dart:html' as html;

class TransactionsUseCase {
  static Future deposit(transaction, client) async {
    final Either result = await client.post(
      "/transactions/deposit",
      body: transaction.toMap(),
    );
    result.fold(
      (left) => null,
      (right) {
        html.window.open(right["url"], "_self");
      },
    );
  }

  static Future withdraw(transaction, client) async {
    final Either result = await client.post(
      "/transactions/withdraw",
      body: transaction.toMap(),
    );
    result.fold(
      (left) => null,
      (right) {
        html.window.open(right["url"], "_self");
      },
    );
  }
}
