import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/common/strings/export.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/data/models/account.dart';
import 'package:stream_challenge/data/models/transaction.dart';
import 'package:stream_challenge/feature/create_challenge/widgets/slider_widget.dart';
import 'package:stream_challenge/providers/providers.dart';
import 'package:stream_challenge/use_cases/transactions.dart';

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
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit(dynamic url) async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    CreateTransactionDTO dto = CreateTransactionDTO(
      amount: double.parse(_controller.text),
      currency: widget.account.currency,
      isDeposit: false,
      returnUrl: url.toString(),
    );
    final client = await ref.read(httpClientProvider.future);
    await TransactionsUseCase.withdraw(dto, client);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AlertDialog(
          title:
              Center(child: Text(AppLocale.of(context).translate(mWithdraw))),
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
              onPressed: () async {
                final router = ref.read(routerProvider);
                await _submit(router.state?.uri);
              },
            )
          ],
        ),
        if (_isLoading) ...[
          // Блокировка интерфейса
          Positioned.fill(
            child: const ModalBarrier(dismissible: false),
          ),
          // Индикатор загрузки в центре и непрозрачность
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ]
      ],
    );
  }
}
