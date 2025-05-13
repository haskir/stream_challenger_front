import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/core/platform/dio.dart';
import 'package:stream_challenge/models/user_preferences.dart';
import 'package:stream_challenge/providers/providers.dart';

import '../models/steamer_info.dart';

/// Requester - клиент для выполнения HTTP-запросов
class _PreferencesRequester {
  final String url = "/user/preferences";
  final Requester httpClient;

  _PreferencesRequester({required this.httpClient});

  Future<Preferences> fetchPreferences() async {
    final response = await httpClient.get(url);
    return response.fold(
      (left) => Preferences.defaultPreferences(),
      (right) => Preferences.fromMap(right),
    );
  }

  Future<Preferences?> updatePreferences(Preferences preferences) async {
    final response = await httpClient.post(url, body: preferences.toMap());
    return response.fold(
      (left) => null,
      (right) => Preferences.fromMap(right),
    );
  }

  Future<StreamerInfo?> getStreamerInfo(String login) async {
    final response = await httpClient.get(
      '$url/$login',
    );
    return response.fold((left) => null, (right) {
      final Map data = Map<String, dynamic>.from(right);
      return StreamerInfo.fromMap(data as Map<String, dynamic>);
    });
  }

  Future<bool> isStreamerOnline(String login) async {
    try {
      final response = await httpClient.get(
        '/panel/is_online',
        {'login': login},
      );
      return response.fold((left) => false, (right) => right);
    } catch (e) {
      print("error in isStreamerOnline $e");
      return false;
    }
  }
}

/// Провайдер для PreferencesClient
final prefRequesterProvider = FutureProvider((ref) async {
  final httpClient = await ref.watch(httpClientProvider.future);
  return _PreferencesRequester(httpClient: httpClient);
});

/// StateNotifier для управления состоянием Preferences
class PreferencesNotifier extends StateNotifier<Preferences> {
  final Ref ref;
  late Preferences onServerPreferences;
  Timer? _timer;

  PreferencesNotifier(this.ref) : super(Preferences.defaultPreferences()) {
    initialize();
  }

  Future<void> initialize() async {
    final authState = ref.watch(authStateProvider);
    if (authState.isAuthenticated) {
      await _fetchPreferences();
    }
  }

  Future<void> _fetchPreferences() async {
    final client = await ref.read(prefRequesterProvider.future);
    onServerPreferences = await client.fetchPreferences();
    state = Preferences.fromMap(onServerPreferences.toMap());
  }

  Future<void> sendPreferences() async {
    if (state == onServerPreferences) {
      return;
    }
    final client = await ref.read(prefRequesterProvider.future);
    onServerPreferences = await client.updatePreferences(state) ?? state;
  }

  Future<void> updatePreferences(Preferences preferences) async {
    state = Preferences.fromMap(preferences.toMap());
    if (ref.watch(authStateProvider).isAuthenticated) {
      _timer?.cancel();
      _timer = Timer(const Duration(seconds: 5), () async {
        await sendPreferences();
        _timer = null;
      });
    }
  }
}

/// Провайдер для PreferencesNotifier
final preferencesProvider = StateNotifierProvider<PreferencesNotifier, Preferences>((ref) {
  return PreferencesNotifier(ref);
});

final streamerInfoProvider = FutureProvider.family<StreamerInfo?, String>((ref, login) async {
  final client = await ref.read(prefRequesterProvider.future);
  return client.getStreamerInfo(login);
});

final isOnlineProvider = FutureProvider.family<bool, String>((ref, login) async {
  final client = await ref.read(prefRequesterProvider.future);
  return client.isStreamerOnline(login);
});
