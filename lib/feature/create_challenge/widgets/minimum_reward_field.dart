import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';

class MinimumRewardField extends StatelessWidget {
  final TextEditingController controller;

  const MinimumRewardField({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    controller.text = '10';
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      maxLength: 3,
      decoration: InputDecoration(
        labelText:
            '${AppLocale.of(context).translate('Minimum Reward')} (10% - 100%)',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocale.of(context).translate('Please enter minimum reward');
        }
        if (double.tryParse(value) == null ||
            double.parse(value) < 0 ||
            double.parse(value) > 100) {
          return AppLocale.of(context)
              .translate('Minimum reward must be between 10% and 100%');
        }
        return null;
      },
    );
  }
}
