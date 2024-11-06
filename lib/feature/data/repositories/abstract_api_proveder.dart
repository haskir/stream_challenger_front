import 'package:dartz/dartz.dart';
import 'package:stream_challenge/core/error/failure.dart';

class CookieManager {
  late final String _cookies;
  String getCookie() {
    return _cookies;
  }

  void setCookie(String? cookie) => _cookies = cookie ?? "";

  CookieManager() {
    _cookies = "";
  }
}

abstract class ApiProveder {
  static const String baseUrl = "api.localhost";
  final CookieManager cookie = CookieManager();
  final String pathUrl;

  ApiProveder({
    required this.pathUrl,
  });

  Future<Either<Failure, T>> get<T>(
    String url, {
    Map<String, String>? headers,
    Map<String, String>? params,
  });
  Future<Either<Failure, T>> post<T>(
    String url, {
    Map<String, String>? headers,
    Map<String, String>? body,
  });
  Future<Either<Failure, T>> put<T>(
    String url, {
    Map<String, String>? headers,
    Map<String, String>? body,
  });
  Future<Either<Failure, T>> delete<T>(
    String url, {
    Map<String, String>? headers,
    Map<String, String>? body,
  });
}
