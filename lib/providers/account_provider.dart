import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/core/platform/dio.dart';
import 'package:stream_challenge/data/models/account.dart';
import 'package:stream_challenge/providers/providers.dart';

/// Клиент для выполнения HTTP-запросов для Account
class _AccountClient {
  final String url = "/accounts";
  final Requester httpClient;

  _AccountClient({required this.httpClient});

  Future<Account?> fetchAccount(Ref ref) async {
    final authState = ref.watch(authStateProvider);
    if (!authState.isAuthenticated) return null;
    final response = await httpClient.get(url);
    return response.fold(
      (left) => null, // Возвращаем null при ошибке
      (right) => Account.fromMap(right),
    );
  }
}

/// Провайдер для AccountClient
final accountClientProvider = Provider<Future<_AccountClient>>((ref) async {
  final httpClient = await ref.watch(httpClientProvider.future);
  return _AccountClient(httpClient: httpClient);
});

/// StateNotifier для управления состоянием Account
class AccountNotifier extends StateNotifier<Account?> {
  final Ref ref;

  AccountNotifier(this.ref) : super(null) {
    initialize();
  }

  /// Инициализация, которая запускает цикл обновления данных
  Future<void> initialize() async {
    final authState = ref.watch(authStateProvider);
    if (authState.isAuthenticated) {
      await _fetchAccount();
      _startUpdateLoop(kDebugMode ? 999 : 60);
    }
  }

  /// Асинхронный цикл обновления данных
  void _startUpdateLoop(int seconds) {
    Timer.periodic(Duration(seconds: seconds), (_) async {
      try {
        await _fetchAccount();
      } catch (e) {
        // Обработка ошибок при запросах (опционально)
      }
    });
  }

  /// Обновление данных Account
  Future<void> _fetchAccount() async {
    final client = await ref.read(accountClientProvider);
    final account = await client.fetchAccount(ref);
    state =
        account; // Если запрос завершился с ошибкой, состояние остаётся null
  }
}

final accountProvider = StateNotifierProvider<AccountNotifier, Account?>(
  (ref) => AccountNotifier(ref),
);
