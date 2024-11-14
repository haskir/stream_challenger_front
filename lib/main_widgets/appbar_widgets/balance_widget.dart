import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/providers.dart';
import 'package:flutter/material.dart';

final Map _currency = {
  "RUB": "₽",
  "EUR": "€",
  "USD": "\$",
  "KZT": "₸",
  "UAH": "₴",
};

class BalanceWidget extends ConsumerWidget {
  const BalanceWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(authStateProvider).user?.account;
    if (balance == null) {
      return Center();
    }
    return Row(
      children: [
        Text('${balance.balance} ${_currency[balance.currency]}'),
        SizedBox(width: 3),
        TextButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(maximumSize: Size(65, 65)),
          child: Icon(Icons.add),
        ),
        SizedBox(width: 3),
      ],
    );
  }
}
