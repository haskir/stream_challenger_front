import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:stream_challenge/data/models/account.dart';
import 'package:stream_challenge/feature/transaction/transaction_dialogs.dart';
import 'package:stream_challenge/providers/account_provider.dart';

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
    double size = 65;
    final Account? account = ref.watch(accountProvider);
    final player = AudioPlayer();
    if (account == null) return Container();
    final String balance = account.balance % 1 == 0
        ? account.balance.toString()
        : account.balance.toStringAsFixed(2);
    return Row(
      children: [
        Text('$balance ${_currency[account.currency]}'),
        SizedBox(width: 3),
        // +
        TextButton(
          onPressed: () async {
            await showDialog<void>(
              context: context,
              builder: (context) => DepositDialog(account: account),
            );
          },
          onLongPress: () async {
            await player.play(
              AssetSource('sounds/green_is_good.mpeg'),
              volume: 0.3,
            );
          },
          style: TextButton.styleFrom(maximumSize: Size(size, size)),
          child: Icon(
            Icons.add,
            size: 20,
          ),
        ),
        // -
        TextButton(
          onPressed: () async {
            await showDialog<void>(
              context: context,
              builder: (context) => WithdrawDialog(account: account),
            );
          },
          onLongPress: () async {},
          style: TextButton.styleFrom(maximumSize: Size(size, size)),
          child: Icon(
            Icons.remove,
            size: 20,
          ),
        ),
      ],
    );
  }
}
