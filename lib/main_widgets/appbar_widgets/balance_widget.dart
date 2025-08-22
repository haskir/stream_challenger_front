import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:stream_challenge/common/strings/_transactions_strings.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/models/account.dart';
import 'package:stream_challenge/feature/transaction/deposit_dialog.dart';
import 'package:stream_challenge/feature/transaction/withdraw_dialog.dart';
import 'package:stream_challenge/providers/account_provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

const Map<String, String> _currency = {
  "RUB": "₽",
  "EUR": "€",
  "USD": "\$",
  "KZT": "₸",
  "UAH": "₴",
};

class BalanceWidget extends ConsumerWidget {
  static final player = AudioPlayer();
  const BalanceWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Account? account = ref.watch(accountProvider);
    if (account == null) return Container();
    final String balance = account.balance % 1 == 0 ? account.balance.toString() : account.balance.toStringAsFixed(2);
    return VisibilityDetector(
      key: Key('account-visibility'),
      onVisibilityChanged: (visibilityInfo) {
        ref.read(accountProvider.notifier).setVisibility(visibilityInfo.visibleFraction > 0);
      },
      child: TextButton(
        child: Text(
          style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
          '$balance ${_currency[account.currency]}',
        ),
        onPressed: () => _showBalanceDialog(context, account),
      ),
    );
  }

  void _showBalanceDialog(BuildContext context, Account account) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(Offset.zero);
    const borderWidght = 1.5;
    const iconSize = 20.0;

    showMenu(
      color: Theme.of(context).primaryColor,
      menuPadding: EdgeInsets.symmetric(horizontal: 3, vertical: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx - button.size.width / 2, // Координаты X для левого края
        position.dy + button.size.height, // Координаты Y (под виджетом)
        position.dx + button.size.width / 2, // Правый край
        position.dy, // Верхний край
      ),
      items: [
        PopupMenuItem(
          padding: EdgeInsets.zero,
          enabled: false, // Отключаем нажатие
          child: ElevatedButton(
            onPressed: () async => await showDialog(
              context: context,
              builder: (context) => WithdrawDialog(account: account),
            ),
            style: ElevatedButton.styleFrom(
              side: BorderSide(
                width: borderWidght,
                color: Colors.red,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  AppLocale.of(context).translate(mWithdraw),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                Icon(Icons.remove, size: iconSize, color: Colors.red),
              ],
            ),
          ),
        ),
        PopupMenuItem(
          padding: EdgeInsets.zero,
          enabled: false, // Отключаем нажатие
          child: ElevatedButton(
            onPressed: () async => await showDialog(
              context: context,
              builder: (context) => DepositDialog(account: account),
            ),
            onLongPress: () async {
              await player.play(
                AssetSource('sounds/green_is_good.mpeg'),
                volume: 0.3,
              );
            },
            style: ElevatedButton.styleFrom(
              side: BorderSide(
                width: borderWidght,
                color: Colors.green,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  AppLocale.of(context).translate(mDeposit),
                  style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                ),
                Icon(
                  Icons.add,
                  size: iconSize,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
