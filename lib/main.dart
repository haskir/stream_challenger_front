import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/platform/app_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'providers.dart';
import 'theme.dart';

class StreamChallengeApp extends ConsumerWidget {
  const StreamChallengeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      locale: locale,
      theme: mainTheme,
      onGenerateTitle: (context) =>
          AppLocalizations.of(context).translate('title'),
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
  setUrlStrategy(PathUrlStrategy());
  runApp(
    const ProviderScope(
      child: StreamChallengeApp(),
    ),
  );
}
