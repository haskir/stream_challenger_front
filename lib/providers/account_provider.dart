import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stream_challenge/core/platform/dio.dart';
import 'package:stream_challenge/models/account.dart';
import 'package:stream_challenge/providers/providers.dart';

/// Клиент для выполнения HTTP-запросов для Account
class _AccountClient {
  final String url = "/account";
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
  Timer? _timer;
  bool _isVisible = true;

  AccountNotifier(this.ref) : super(null) {
    initialize();
  }

  /// Инициализация, которая запускает цикл обновления данных
  Future<void> initialize() async {
    final authState = ref.watch(authStateProvider);
    if (authState.isAuthenticated) {
      await refresh();
      _startUpdateLoop(30);
    }
  }

  void setVisibility(bool visible) {
    print("setVisibility $visible");
    _isVisible = visible;
    if (visible) {
      refresh(); // Обновить данные сразу после возвращения
    }
  }

  void _startUpdateLoop(int seconds) {
    _timer = Timer.periodic(Duration(seconds: seconds), (_) async {
      try {
        if (_isVisible) {
          await refresh();
        }
      } catch (e) {
        // Обработка ошибок
      }
    });
  }

  void stopUpdateLoop() {
    _timer?.cancel();
    _timer = null;
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
