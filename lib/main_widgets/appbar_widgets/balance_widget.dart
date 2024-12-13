import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:stream_challenge/data/models/account.dart';
import 'package:stream_challenge/data/models/transaction.dart';
import 'package:stream_challenge/feature/transaction/deposit_dialog.dart';
import 'package:stream_challenge/feature/transaction/withdraw_dialog.dart';
import 'package:stream_challenge/providers/account_provider.dart';
import 'package:stream_challenge/providers/providers.dart';
import 'package:stream_challenge/use_cases/transactions.dart';
import 'package:visibility_detector/visibility_detector.dart';

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
    return VisibilityDetector(
        key: Key('account-visibility'),
        onVisibilityChanged: (visibilityInfo) {
          ref
              .read(accountProvider.notifier)
              .setVisibility(visibilityInfo.visibleFraction > 0);
        },
        child: Row(
          children: [
            Text('$balance ${_currency[account.currency]}'),
            SizedBox(width: 3),
            // +
            TextButton(
              onPressed: () async {
                CreateTransactionDTO? dto =
                    await showDialog<CreateTransactionDTO>(
                  context: context,
                  builder: (context) => DepositDialog(account: account),
                );
                if (dto == null) return;
                final client = await ref.read(httpClientProvider.future);
                TransactionsUseCase.deposit(dto, client);
              },
              onLongPress: () async {
                await player.play(
                  AssetSource('sounds/green_is_good.mpeg'),
                  volume: 0.3,
                );
              },
              style: TextButton.styleFrom(maximumSize: Size(size, size)),
              child: Icon(Icons.add, size: 20),
            ),
            // -
            TextButton(
              onPressed: () async {
                CreateTransactionDTO? dto =
                    await showDialog<CreateTransactionDTO>(
                  context: context,
                  builder: (context) => WithdrawDialog(account: account),
                );
                if (dto == null) return;
                final client = await ref.read(httpClientProvider.future);
                TransactionsUseCase.withdraw(dto, client);
              },
              onLongPress: () async {},
              style: TextButton.styleFrom(maximumSize: Size(size, size)),
              child: Icon(Icons.remove, size: 20),
            ),
          ],
        ));
  }
}
