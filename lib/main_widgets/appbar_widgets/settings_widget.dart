import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_challenge/common/strings/export.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/providers/providers.dart';
import 'package:stream_challenge/data/models/user_preferences.dart';
import 'package:stream_challenge/providers/preferences_provider.dart';

class SettingsWidget extends ConsumerStatefulWidget {
  static const Map<String, String> languagesHeaders = {
    'EN': 'Русский язык',
    'RU': 'English language'
  };
  const SettingsWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<SettingsWidget> {
  static String swtchLang(String language) {
    switch (language) {
      case 'EN':
        return 'RU';
      case 'RU':
        return 'EN';
      default:
        return 'EN';
    }
  }

  String themeText(bool? darkMode) {
    switch (darkMode) {
      case true:
        return AppLocale.of(context).translate(mDarkTheme);
      case false:
        return AppLocale.of(context).translate(mLightTheme);
      default:
        return AppLocale.of(context).translate(mSystemTheme);
    }
  }

  @override
  Widget build(BuildContext context) {
    Preferences preferences = ref.watch(preferencesProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Выбор языка
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocale.of(context).translate(
                  SettingsWidget.languagesHeaders[preferences.language]!),
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color),
            ),
            IconButton(
              onPressed: () async {
                preferences.language = swtchLang(preferences.language);
                await ref
                    .read(preferencesProvider.notifier)
                    .updatePreferences(preferences);
              },
              icon: const Icon(Icons.language),
              color: Theme.of(context).iconTheme.color,
            ),
          ],
        ),
        // Выбор цветовой темы
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocale.of(context).translate(themeText(preferences.darkMode)),
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Солнце
                IconButton(
                  onPressed: () async {
                    preferences.darkMode = false;
                    await ref
                        .read(preferencesProvider.notifier)
                        .updatePreferences(preferences);
                  },
                  icon: preferences.darkMode == false
                      ? const Icon(Icons.light_mode)
                      : const Icon(Icons.light_mode_outlined),
                  color: Theme.of(context).iconTheme.color,
                ),
                // Луна
                IconButton(
                  onPressed: () async {
                    preferences.darkMode = true;
                    await ref
                        .read(preferencesProvider.notifier)
                        .updatePreferences(preferences);
                  },
                  icon: preferences.darkMode == true
                      ? const Icon(Icons.dark_mode)
                      : const Icon(Icons.dark_mode_outlined),
                  color: Theme.of(context).iconTheme.color,
                ),
                // Системная
                IconButton(
                  onPressed: () async {
                    preferences.darkMode = null;
                    await ref
                        .read(preferencesProvider.notifier)
                        .updatePreferences(preferences);
                  },
                  icon: preferences.darkMode == null
                      ? const Icon(Icons.settings)
                      : const Icon(Icons.settings_outlined),
                  color: Theme.of(context).iconTheme.color,
                ),
              ],
            ),
          ],
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
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            Preferences preferences = ref.read(preferencesProvider);
            preferences.language =
                _SettingsState.swtchLang(preferences.language);
            await ref
                .read(preferencesProvider.notifier)
                .updatePreferences(preferences);
          },
          icon: const Icon(Icons.language_outlined),
        ),
        TextButton.icon(
          label: Text(AppLocale.of(context).translate(mAuth)),
          icon: const Icon(Icons.login),
          onPressed: () async {
            await ref.read(authStateProvider.notifier).auth(context);
          },
        ),
      ],
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
          title: Center(
            child: Text(AppLocale.of(context).translate(mSettings)),
          ),
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
