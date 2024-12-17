import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/data/models/user_preferences.dart';
import 'package:stream_challenge/providers/preferences_provider.dart';

class SettingsWidget extends ConsumerStatefulWidget {
  const SettingsWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LocaleState();
}

class _LocaleState extends ConsumerState<SettingsWidget> {
  @override
  Widget build(BuildContext context) {
    Preferences preferences = ref.watch(preferencesProvider);

    String switchLanguage(String language) {
      switch (language) {
        case 'EN':
          return 'RU';
        case 'RU':
          return 'EN';
        default:
          return 'EN';
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Выбор языка
        TextButton(
          onPressed: () async {
            preferences.language = switchLanguage(preferences.language);
            await ref
                .read(preferencesProvider.notifier)
                .updatePreferences(preferences);
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Text(
              switchLanguage(preferences.language),
              style: preferences.darkMode
                  ? const TextStyle(color: Colors.white)
                  : const TextStyle(color: Colors.black),
            ),
          ),
        ),
        // Выбор цветовой темы
        IconButton(
          onPressed: () async {
            preferences.darkMode = !preferences.darkMode;
            await ref
                .read(preferencesProvider.notifier)
                .updatePreferences(preferences);
          },
          icon: Icon(
            preferences.darkMode
                ? Icons.wb_sunny_outlined
                : Icons.nightlight_outlined,
            color: preferences.darkMode ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }
}
