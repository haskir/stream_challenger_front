import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenRepo {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    String? token = await _storage.read(key: 'authToken');
    try {
      JwtDecoder.decode(token!);
    } catch (e) {
      return null;
    }
    return token;
  }

  Future<void> setToken(String token) async {
    await _storage.write(key: 'authToken', value: token);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'authToken');
  }
}
