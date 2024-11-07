import 'package:flutter/material.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';

class LocaleWidget extends StatelessWidget {
  const LocaleWidget({super.key, required this.onLocaleChange});

  final ValueChanged<String> onLocaleChange;

  List<DropdownMenuItem<String>> languages() => [
        const DropdownMenuItem(
          value: 'en',
          child: Text('English'),
        ),
        const DropdownMenuItem(
          value: 'ru',
          child: Text('Русский'),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('title')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              items: languages(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onLocaleChange(newValue);
                }
              },
              value: Localizations.localeOf(context).languageCode,
            ),
            Text(AppLocalizations.of(context).translate('title')),
          ],
        ),
      ),
    );
  }
}
