import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/core/platform/dio.dart';
import 'package:stream_challenge/data/models/user_preferences.dart';
import 'package:stream_challenge/providers/providers.dart';

/// Requester - клиент для выполнения HTTP-запросов
class _PreferencesClient {
  final String url = "/preferences";
  final Requester httpClient;

  _PreferencesClient({required this.httpClient});

  Future<Preferences> fetchPreferences() async {
    final response = await httpClient.get(url);
    return response.fold(
      (left) => Preferences.defaultPreferences(),
      (right) => Preferences.fromMap(right),
    );
  }

  Future<Preferences?> updatePreferences(Preferences preferences) async {
    final response = await httpClient.post(
      url,
      body: preferences.toMap(),
    );
    return response.fold(
      (left) => null,
      (right) => Preferences.fromMap(right),
    );
  }

  Future<Preferences?> getPerformerPreferences(String login) async {
    final response = await httpClient.get('$url/performer/$login');
    return response.fold(
      (left) => null,
      (right) => Preferences.fromMap(right),
    );
  }
}

/// Провайдер для PreferencesClient
final preferencesClientProvider =
    FutureProvider<_PreferencesClient>((ref) async {
  final httpClient = await ref.watch(httpClientProvider.future);
  return _PreferencesClient(httpClient: httpClient);
});

/// StateNotifier для управления состоянием Preferences
class PreferencesNotifier extends StateNotifier<Preferences> {
  final Ref ref;

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
    final client = await ref.read(preferencesClientProvider.future);
    final preferences = await client.fetchPreferences();
    state = preferences;
  }

  Future<void> updatePreferences(Preferences preferences) async {
    final client = await ref.read(preferencesClientProvider.future);
    final updatedPreferences = await client.updatePreferences(preferences);
    if (updatedPreferences != null) {
      state = updatedPreferences;
    }
  }

  Future<void> updateLanguage(String language) async {
    state.language = language;
    await updatePreferences(state);
  }
}

/// Провайдер для PreferencesNotifier
final preferencesProvider =
    StateNotifierProvider<PreferencesNotifier, Preferences>(
  (ref) => PreferencesNotifier(ref),
);

final performerPreferencesProvider =
    FutureProvider.family<Preferences?, String>(
  (ref, login) async {
    final client = await ref.read(preferencesClientProvider.future);
    return await client.getPerformerPreferences(login);
  },
);
