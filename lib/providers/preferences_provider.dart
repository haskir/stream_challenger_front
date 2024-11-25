import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/core/platform/dio.dart';
import 'package:stream_challenge/data/models/user_preferences.dart';
import 'package:stream_challenge/providers/account_provider.dart';
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

  Future<double?> getMinimumInCurrency(String login, String currency) async {
    final response = await httpClient.get(
      '$url/minimum_in_currency',
      {'login': login, 'currency': currency},
    );
    return response.fold((left) => null, (right) {
      final Map data = Map<String, dynamic>.from(right);
      return double.tryParse(data['minimum'].toString());
    });
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

final minimumInCurrencyProvider =
    FutureProvider.autoDispose.family<double?, String>(
  (ref, login) async {
    final account = ref.watch(accountProvider);
    if (account == null) return null;

    final client = await ref.read(preferencesClientProvider.future);
    return client.getMinimumInCurrency(login, account.currency);
  },
);
