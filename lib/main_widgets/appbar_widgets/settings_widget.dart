import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_challenge/common/strings/export.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/providers/providers.dart';
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

    return Column(
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                switchLanguage(preferences.language),
                style: preferences.darkMode
                    ? const TextStyle(color: Colors.white)
                    : const TextStyle(color: Colors.black),
              ),
              const SizedBox(width: 5),
              const Icon(Icons.language, color: Colors.white),
            ],
          ),
        ),
        // Выбор цветовой темы
        TextButton(
          onPressed: () async {
            preferences.darkMode = !preferences.darkMode;
            await ref
                .read(preferencesProvider.notifier)
                .updatePreferences(preferences);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                preferences.darkMode
                    ? AppLocale.of(context).translate(mLightTheme)
                    : AppLocale.of(context).translate(mDarkTheme),
                style: preferences.darkMode
                    ? const TextStyle(color: Colors.white)
                    : const TextStyle(color: Colors.black),
              ),
              const SizedBox(width: 5),
              Icon(
                preferences.darkMode
                    ? Icons.wb_sunny_outlined
                    : Icons.nightlight_outlined,
                color: preferences.darkMode ? Colors.white : Colors.black,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AuthWidget extends ConsumerWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    // Если пользователь авторизован
    if (authState.isAuthenticated) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => _showSettingsDialog(context, ref, authState),
              icon: CircleAvatar(
                radius: 20,
                backgroundImage:
                    NetworkImage(authState.user!.profile_image_url),
              ),
            ),
            const SizedBox(width: 5),
          ],
        ),
      );
    }

    // Если пользователь не авторизован
    return Center(
      child: TextButton(
        child: Text(AppLocale.of(context).translate(mAuth)),
        onPressed: () async {
          await ref.read(authStateProvider.notifier).auth(context);
        },
      ),
    );
  }

  /// Метод для отображения диалога с настройками и кнопкой выхода
  void _showSettingsDialog(BuildContext context, WidgetRef ref, authState) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(AppLocale.of(context).translate(mSettings)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SettingsWidget(), // Включаем виджет настроек
              const Divider(), // Разделитель
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(); // Закрыть диалог
                  context.go('/'); // Вернуться на главную
                  await ref.read(authStateProvider.notifier).logout();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocale.of(context).translate(mLogout),
                      style: const TextStyle(color: Colors.red),
                    ),
                    Icon(Icons.logout, color: Colors.red),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
