import 'package:flutter/material.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';

class DescriptionField extends StatelessWidget {
  final TextEditingController controller;

  const DescriptionField({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLength: 255,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context).translate("Description"),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)
              .translate("Please enter description");
        }
        return null;
      },
    );
  }
}
