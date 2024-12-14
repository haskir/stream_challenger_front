import 'package:flutter/material.dart';
import 'package:stream_challenge/data/models/transaction.dart';

class TransactionViewWidget extends StatelessWidget {
  final Transaction transaction;
  const TransactionViewWidget({super.key, required this.transaction});

  static const Map<String, Color> colors = {
    "PENDING": Colors.orange,
    "COMPLETED": Colors.green,
    "CANCELLED": Colors.grey,
    "FAILED": Colors.red,
  };

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 550,
        maxWidth: 700,
      ),
      child: Card(
        color: colors[transaction.status],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text(transaction.toString())],
          ),
        ),
      ),
    );
  }
}
