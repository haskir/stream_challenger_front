import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stream_challenge/models/user_preferences.dart';
import 'package:stream_challenge/providers/preferences_provider.dart';
import 'package:stream_challenge/common/strings/export.dart';
import 'core/platform/app_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'providers/providers.dart';
import 'common/theme.dart';

class StreamChallengeApp extends ConsumerWidget {
  const StreamChallengeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsFlutterBinding.ensureInitialized();
    final Preferences preferences = ref.watch(preferencesProvider);
    final router = ref.watch(routerProvider);
    bool isDark = preferences.darkMode ?? (MediaQuery.of(context).platformBrightness == Brightness.dark);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      locale: Locale(preferences.language.toLowerCase()),
      theme: isDark ? darkTheme : lightTheme,
      onGenerateTitle: (context) => AppLocale.of(context).translate(mTitle),
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ru', 'RU'),
      ],
    );
  }
}

void main() {
  // debugPaintSizeEnabled = true;
  setUrlStrategy(PathUrlStrategy());
  final container = ProviderContainer();
  container.read(preferencesProvider.notifier);
  container.read(authStateProvider.notifier);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const StreamChallengeApp(),
    ),
  );
}
