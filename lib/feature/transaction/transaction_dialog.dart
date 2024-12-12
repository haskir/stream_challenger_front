import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/common/text_consts.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/data/models/account.dart';
import 'package:stream_challenge/data/models/currency.dart';
import 'package:stream_challenge/feature/create_challenge/widgets/bet_slider.dart';

class TransactionDialog extends ConsumerStatefulWidget {
  final bool isDeposit;
  final Account account;
  const TransactionDialog({
    super.key,
    required this.isDeposit,
    required this.account,
  });

  @override
  createState() => _TransactionWidgetState();
}

class _TransactionWidgetState extends ConsumerState<TransactionDialog> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String title = AppLocale.of(context)
        .translate(widget.isDeposit ? "Deposit" : "Withdraw");
    return AlertDialog(
      title: Center(child: Text(title)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Пополнение
          if (widget.isDeposit) ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 150),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        labelText: AppLocale.of(context).translate(mAmount)),
                  ),
                ),
                DropdownMenu(
                    dropdownMenuEntries: CurrencyConverter.getCurrencyList()
                        .map((e) => DropdownMenuEntry(
                              value: e,
                              label: e,
                            ))
                        .toList(),
                    initialSelection: widget.account.currency,
                    onSelected: (value) {}),
              ],
            ),
            SizedBox(height: 20),
          ],
          // Вывод
          if (!widget.isDeposit)
            BetSlider(
              controller: _controller,
              currency: widget.account.currency,
              minBet: 0,
              maximum: widget.account.balance,
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextButton(
                  child: Text(AppLocale.of(context).translate(mCancel)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  child: Text(AppLocale.of(context).translate(mSubmit)),
                  onPressed: () => Navigator.of(context).pop(_controller.text),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
