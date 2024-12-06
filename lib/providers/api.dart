import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApiPath {
  static const url = 'localhost';
  static const prefix = 'api';
  static const security = false;

  static String get http {
    if (security) return 'https://$url:443/$prefix/';
    return 'http://$url:80/$prefix/';
  }

  static String get ws {
    if (security) return 'wss://$url:443/$prefix/';
    return 'ws://$url:80/$prefix/';
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

    // ignore: unused_element
    bool listContains(List<String> text) {
      return text.any(wordIsRestricted);
    }
  }
}

final restrictedWordsChecker = Provider<RestrictedWordsChecker>((ref) {
  return RestrictedWordsChecker();
});
