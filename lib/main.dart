import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'core/platform/app_localization.dart';
import 'widgets/main_widget.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'widgets/router.dart';

class StreamChallengeApp extends StatefulWidget {
  const StreamChallengeApp({super.key});

  @override
  State<StreamChallengeApp> createState() => _StreamChallengeAppState();
}

class _StreamChallengeAppState extends State<StreamChallengeApp> {
  final StreamController<Locale> _localeStreamController =
      StreamController<Locale>();

  @override
  void dispose() {
    _localeStreamController.close();
    super.dispose();
  }

  void _changeLocale(String languageCode) {
    _localeStreamController.add(Locale(languageCode));
  }

  late final GoRouter _router = GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainWidget(onLocaleChange: _changeLocale, child: child);
        },
        routes: routes,
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Locale>(
      stream: _localeStreamController.stream,
      initialData: const Locale('en'),
      builder: (context, snapshot) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerDelegate: _router.routerDelegate,
          routeInformationParser: _router.routeInformationParser,
          routeInformationProvider: _router.routeInformationProvider,
          locale: snapshot.data,
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
      },
    );
  }
}

void main() {
  setUrlStrategy(PathUrlStrategy());
  runApp(const StreamChallengeApp());
}
