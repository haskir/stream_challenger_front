import 'package:flutter/material.dart';
import 'package:stream_challenge/common/text_consts.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';

class DescriptionField extends StatelessWidget {
  final TextEditingController controller;

  const DescriptionField({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLength: 127,
      decoration: InputDecoration(
        labelText: AppLocale.of(context).translate(mDescription),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocale.of(context).translate(mPleaseEnterDescription);
        }
        return null;
      },
    );
  }
}
