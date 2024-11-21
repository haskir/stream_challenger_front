// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';

import 'package:stream_challenge/core/platform/auth_state.dart';
import 'package:stream_challenge/data/models/currency.dart';

class CurrencyPickWidget extends ConsumerWidget {
  final AuthToken user;

  const CurrencyPickWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownButtonFormField<String>(
      // value: user.account.currency,
      value: "RUB",
      items: CurrencyConverter.getCurrencyList()
          .map((currency) =>
              DropdownMenuItem(value: currency, child: Text(currency)))
          .toList(),
      onChanged: null,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context).translate("Currency"),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)
              .translate('Please select currency');
        }
        return null;
      },
    );
  }
}
