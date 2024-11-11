// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stream_challenge/core/platform/auth_state.dart';
import 'package:stream_challenge/data/models/currency.dart';

class CurrencyPickWidget extends ConsumerWidget {
  final AuthToken user;

  const CurrencyPickWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownButtonFormField<String>(
      value: user.account.currency,
      items: CurrencyConverter.getCurrencyList()
          .map((currency) =>
              DropdownMenuItem(value: currency, child: Text(currency)))
          .toList(),
      onChanged: null,
      decoration: const InputDecoration(
        labelText: 'Валюта',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Пожалуйста, выберите валюту';
        }
        return null;
      },
    );
  }
}
