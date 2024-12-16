import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/common/text_consts.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/data/models/account.dart';
import 'package:stream_challenge/data/models/currency.dart';
import 'package:stream_challenge/data/models/transaction.dart';
import 'package:stream_challenge/providers/providers.dart';
import 'package:stream_challenge/use_cases/transactions.dart';

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
      isDeposit: true,
      returnUrl: url.toString(),
    );
    final client = await ref.read(httpClientProvider.future);
    await TransactionsUseCase.deposit(dto, client);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = AppLocale.of(context).translate(mDeposit);
    return Stack(
      children: [
        AlertDialog(
          title: Center(child: Text(title)),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 100),
                      child: TextFormField(
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: AppLocale.of(context).translate(mAmount),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocale.of(context)
                                .translate(mPleaseEnterAmount);
                          }
                          try {
                            double num = double.parse(value);
                            if (num <= 0) {
                              return AppLocale.of(context)
                                  .translate(mInvalidAmount);
                            }
                          } catch (e) {
                            return AppLocale.of(context)
                                .translate(mInvalidAmount);
                          }
                          return null;
                        },
                        maxLength: 10,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 10),
                    DropdownMenu(
                      dropdownMenuEntries: CurrencyConverter.getCurrencyList()
                          .map((e) => DropdownMenuEntry(value: e, label: e))
                          .toList(),
                      initialSelection: widget.account.currency,
                    ),
                  ],
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
