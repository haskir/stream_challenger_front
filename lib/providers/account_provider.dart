import 'dart:async';
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
      (left) => null,
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
      await refresh();
      _startUpdateLoop(60);
    }
  }

  /// Асинхронный цикл обновления данных
  void _startUpdateLoop(int seconds) {
    Timer.periodic(Duration(seconds: seconds), (_) async {
      try {
        await refresh();
      } catch (e) {
        // Обработка ошибок при запросах (опционально)
      }
    });
  }

  /// Обновление данных Account
  Future<void> refresh() async {
    final client = await ref.read(accountClientProvider);
    final account = await client.fetchAccount(ref);
    if (account == state) return;
    state = account;
  }
}

final accountProvider = StateNotifierProvider<AccountNotifier, Account?>((ref) {
  return AccountNotifier(ref);
});
