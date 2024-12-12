import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/common/text_consts.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/data/models/account.dart';
import 'package:stream_challenge/data/models/transaction.dart';
import 'package:stream_challenge/feature/create_challenge/widgets/slider_widget.dart';

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
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text(AppLocale.of(context).translate(mWithdraw))),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SliderWidget(
              controller: _controller,
              currency: widget.account.currency,
              minimum: 1,
              maximum: widget.account.balance,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text(AppLocale.of(context).translate(mCancel)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
            child: Text(AppLocale.of(context).translate(mSubmit)),
            onPressed: () {
              if (!_formKey.currentState!.validate()) return;
              _formKey.currentState!.save();
              CreateTransactionDTO dto = CreateTransactionDTO(
                amount: double.parse(_controller.text),
                currency: widget.account.currency,
                isDeposit: false,
              );
              Navigator.of(context).pop(dto);
            })
      ],
    );
  }
}
