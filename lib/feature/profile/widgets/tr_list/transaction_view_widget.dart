import 'package:flutter/material.dart';
import 'package:stream_challenge/common/strings/export.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/models/transaction.dart';

class TransactionViewWidget extends StatelessWidget {
  final Transaction transaction;
  const TransactionViewWidget({super.key, required this.transaction});

  static const Map<String, Color> colors = {
    "PENDING": Colors.orange,
    "COMPLETED": Colors.green,
    "CANCELLED": Colors.grey,
    "FAILED": Colors.red,
  };

  static const Map<String, String> statuses = {
    "PENDING": mPending,
    "COMPLETED": mCompleted,
    "CANCELLED": mCancelled,
    "FAILED": mTrError,
  };

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 200,
        maxWidth: 700,
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 10),
              _buildDetails(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          transaction.type == "DEPOSIT"
              ? AppLocale.of(context).translate(mDeposit)
              : AppLocale.of(context).translate(mWithdraw),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: transaction.type == "DEPOSIT" ? Colors.green : Colors.red,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: TransactionViewWidget.colors[transaction.status] ?? Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            AppLocale.of(context).translate(TransactionViewWidget.statuses[transaction.status]!),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(AppLocale.of(context).translate(mAmount),
            "${transaction.amount.toStringAsFixed(2)} ${transaction.currency}", context),
        const SizedBox(height: 5),
        _buildDetailRow(AppLocale.of(context).translate(mCreatedAt), _formatDate(transaction.createdAt), context),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocale.of(context).translate(label),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(AppLocale.of(context).translate(value)),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }
}
