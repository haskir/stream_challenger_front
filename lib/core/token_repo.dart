import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenRepo {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await _storage.read(key: 'authToken');
  }

  Future<void> setToken(String token) async {
    await _storage.write(key: 'authToken', value: token);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'authToken');
  }
}
