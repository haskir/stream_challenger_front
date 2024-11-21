import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/providers/providers.dart';

class LocaleWidget extends ConsumerWidget {
  const LocaleWidget({super.key});

  List<DropdownMenuItem<String>> languages() => [
        const DropdownMenuItem(value: 'en', child: Text('English')),
        const DropdownMenuItem(value: 'ru', child: Text('Русский')),
      ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

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
                  ref.read(localeProvider.notifier).state = Locale(newValue);
                }
              },
              value: locale.languageCode,
            ),
            Text(AppLocalizations.of(context).translate('title')),
          ],
        ),
      ),
    );
  }
}
