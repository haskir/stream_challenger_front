import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:stream_challenge/data/models/account.dart';
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
    final Account? account = ref.watch(accountProvider);
    final player =
        AudioPlayer(); // Создаем аудиоплеер для воспроизведения звука
    if (account == null) return Container();
    int indexOfDot = account.balance.toString().indexOf(".");
    String balanceStr = account.balance.toString();
    late String balance;
    if (indexOfDot == -1) {
      balance = balanceStr;
    } else {
      if (balanceStr.length - indexOfDot - 3 < 0) {
        balance = balanceStr;
      } else {
        balance = account.balance.toString().substring(0, indexOfDot + 3);
      }
    }
    return Row(
      children: [
        Text('$balance ${_currency[account.currency]}'),
        SizedBox(width: 3),
        TextButton(
          onPressed: () {},
          onLongPress: () async {
            await player.play(
              AssetSource('sounds/green_is_good.mpeg'),
              volume: 0.3,
            );
          },
          style: ElevatedButton.styleFrom(maximumSize: Size(65, 65)),
          child: Icon(Icons.add),
        ),
      ],
    );
  }
}
