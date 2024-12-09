import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/data/models/user_preferences.dart';
import 'package:stream_challenge/providers/preferences_provider.dart';

class LocaleWidget extends ConsumerStatefulWidget {
  const LocaleWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LocaleState();
}

class _LocaleState extends ConsumerState<LocaleWidget> {
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
        TextButton(
          onPressed: () async {
            preferences.language = switchLanguage(preferences.language);
            await ref
                .read(preferencesProvider.notifier)
                .updatePreferences(preferences);
          },
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Center(
              child: Text(
                switchLanguage(preferences.language),
                style: preferences.darkMode
                    ? const TextStyle(color: Colors.white)
                    : const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
