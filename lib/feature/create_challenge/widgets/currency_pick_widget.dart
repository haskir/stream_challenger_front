import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/data/models/currency.dart';

class CurrencyPickWidget extends ConsumerWidget {
  final String? currency;

  const CurrencyPickWidget({super.key, required this.currency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownButtonFormField<String>(
      value: currency ?? 'UNDEFIEND',
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
