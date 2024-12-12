import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/common/text_consts.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/data/models/account.dart';
import 'package:stream_challenge/data/models/currency.dart';
import 'package:stream_challenge/feature/create_challenge/widgets/slider_widget.dart';

class DepositDialog extends ConsumerStatefulWidget {
  final Account account;
  const DepositDialog({
    super.key,
    required this.account,
  });

  @override
  createState() => _DepositWidgetState();
}

class _DepositWidgetState extends ConsumerState<DepositDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String title = AppLocale.of(context).translate(mDeposit);
    return AlertDialog(
      title: Center(child: Text(title)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                  maxLength: 10,
                  maxLines: 1,
                ),
              ),
              DropdownMenu(
                dropdownMenuEntries: CurrencyConverter.getCurrencyList()
                    .map((e) => DropdownMenuEntry(value: e, label: e))
                    .toList(),
                initialSelection: widget.account.currency,
              ),
            ],
          ),
          SizedBox(height: 20),
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
                  onPressed: () => Navigator.of(context).pop(),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class WithdrawDialog extends ConsumerStatefulWidget {
  final Account account;
  const WithdrawDialog({
    super.key,
    required this.account,
  });

  @override
  createState() => _WithdrawWidgetState();
}

class _WithdrawWidgetState extends ConsumerState<WithdrawDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text(AppLocale.of(context).translate(mWithdraw))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SliderWidget(
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
                  onPressed: () => Navigator.of(context).pop(),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
