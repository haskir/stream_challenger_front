import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/platform/auth_client.dart';
import 'core/platform/auth_state.dart';
import 'main_widgets/main_widget.dart';
import 'main_widgets/router.dart';

final localeProvider = StateProvider<Locale>((ref) => const Locale('en'));
final authStateProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());

final routerProvider = Provider<GoRouter>((ref) {
  final changeLocale = ref.read(localeProvider.notifier);

  return GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainWidget(
            onLocaleChange: (languageCode) =>
                changeLocale.state = Locale(languageCode),
            child: child,
          );
        },
        routes: routes,
      ),
    ],
  );
});

class ApiPath {
  static const url = 'localhost';
  static const security = false;

  static String get http {
    if (security) return 'https://$url:443';
    return 'http://$url:80';
  }

  static String get ws {
    if (security) return 'wss://$url:443';
    return 'ws://$url:80';
  }
}

class RestrictedWordsChecker {
  late final List<String> words;

  RestrictedWordsChecker() {
    init();
  }

  Future<void> init() async {
    final jsonString =
        await rootBundle.loadString('assets/locales/restricted_words.json');
    final data = jsonDecode(jsonString);
    words = data.cast<String>();

    bool wordIsRestricted(String text) {
      return words
          .any((word) => text.toLowerCase().contains(word.toLowerCase()));
    }

    bool listContains(List<String> text) {
      return text.any(wordIsRestricted);
    }
  }
}

final restrictedWordsChecker = Provider<RestrictedWordsChecker>((ref) {
  return RestrictedWordsChecker();
});
