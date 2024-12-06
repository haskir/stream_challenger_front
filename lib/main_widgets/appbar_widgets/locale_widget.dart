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
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(switchLanguage(preferences.language)),
          ),
        ),
      ],
    );
  }
}
