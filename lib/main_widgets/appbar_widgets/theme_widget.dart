import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/data/models/user_preferences.dart';
import 'package:stream_challenge/providers/preferences_provider.dart';

class ThemeWidget extends ConsumerStatefulWidget {
  const ThemeWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ThemeState();
}

class _ThemeState extends ConsumerState<ThemeWidget> {
  @override
  Widget build(BuildContext context) {
    Preferences preferences = ref.watch(preferencesProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
