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
