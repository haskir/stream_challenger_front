import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:stream_challenge/core/error/failure.dart';
import 'package:stream_challenge/providers.dart';
import 'response.dart';

abstract class _Client {
  Future<Either<ErrorDTO, Map<String, dynamic>>> get(
    String url, [
    Map<String, dynamic> params = const {},
  ]);

  Future<Either<ErrorDTO, bool>> post(String url, Map<String, dynamic> body);

  Future<Either<ErrorDTO, bool>> delete(String url);

  Future<Either<ErrorDTO, bool>> put(String url, Map<String, dynamic> body);
}

class Requester implements _Client {
  final Dio _dio = Dio();
  String token;

  Requester(this.token) {
    _dio.options.baseUrl = ApiPath.http;
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    if (kDebugMode) {
      _dio.interceptors.add(
          LogInterceptor(request: true, requestBody: true, responseBody: true));
    }
  }

  ErrorDTO _processResponse(Response response) {
    return ErrorDTO.fromMap(response.data);
  }

  Future<Either<ErrorDTO, T>> _request<T>(
    String method,
    String url, {
    Map<String, dynamic> params = const {},
    Map<String, dynamic> body = const {},
    T Function(dynamic data)? parser,
  }) async {
    try {
      final response = await _dio.request(url,
          data: body,
          queryParameters: params,
          options: Options(method: method));

      if (response.statusCode == 200) {
        if (parser != null) {
          final parsed = parser(response.data);
          return Right(parsed);
        } else if (T == bool) {
          return Right(true as T);
        } else {
          return Right(response.data as T);
        }
      }
      return Left(_processResponse(response));
    } on DioException catch (e) {
      return Left(_processResponse(e.response!));
    }
  }

  @override
  get(
    String url, [
    Map<String, dynamic> params = const {},
  ]) {
    return _request<Map<String, dynamic>>('GET', url,
        params: params, parser: (data) => Map<String, dynamic>.from(data));
  }

  @override
  post(String url, Map<String, dynamic> body) {
    return _request<bool>('POST', url, body: body);
  }

  @override
  put(String url, Map<String, dynamic> body) {
    return _request<bool>('PUT', url, body: body);
  }

  @override
  delete(String url) {
    return _request<bool>('DELETE', url);
  }
}
