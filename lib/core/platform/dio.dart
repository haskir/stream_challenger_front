import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:stream_challenge/providers/api.dart';
import 'response.dart';

abstract class _Client {
  Future<Either<ErrorDTO, dynamic>> get(
    String url, [
    Map<String, dynamic> params = const {},
  ]);

  Future<Either<ErrorDTO, Map<String, dynamic>>> post(
    String url, {
    Map<String, dynamic> query,
    Map<String, dynamic> body,
  });

  Future<Either<ErrorDTO, bool>> delete(String url);

  Future<Either<ErrorDTO, bool>> put(String url, Map<String, dynamic> body);
}

class Requester implements _Client {
  final Dio _dio = Dio();
  String token;

  Requester(this.token) {
    _dio.options.baseUrl = kDebugMode ? ApiPathDebug.http : ApiPathSecured.http;
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'Access-Control-Allow-Origin': 'localhost',
    };
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        request: false,
        requestBody: false,
        responseBody: true,
        requestHeader: false,
        responseHeader: false,
      ));
    }
  }

  ErrorDTO _processResponse(Response response) {
    return ErrorDTO.fromMap(response.data);
  }

  Future<Either<ErrorDTO, T>> _request<T>(
    String method,
    String url, {
    Map<String, dynamic> params = const {},
    dynamic body = const {},
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
      if (response.statusCode == 500) {
        return Left(ErrorDTO(
          code: 500,
          message: 'Server error',
          type: 'error',
        ));
      }
      return Left(_processResponse(response));
    } on DioException catch (e) {
      return Left(ErrorDTO(
        code: e.response?.statusCode ?? 1,
        message: e.message ?? 'Unknown error',
        type: 'error',
      ));
    }
  }

  @override
  get(
    String url, [
    Map<String, dynamic> params = const {},
  ]) {
    return _request<dynamic>(
      'GET',
      url,
      params: params,
      parser: (data) {
        if (data is List) {
          return List<dynamic>.from(data); // Если ответ — List
        } else if (data is Map) {
          return Map<String, dynamic>.from(data); // Если ответ — Map
        } else {
          return data;
        }
      },
    );
  }

  @override
  post(
    url, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? body,
  }) {
    return _request<Map<String, dynamic>>('POST', url,
        params: query ?? {}, body: body ?? {});
  }

  @override
  put(url, body) {
    return _request<bool>('PUT', url, body: body);
  }

  @override
  delete(url) {
    return _request<bool>('DELETE', url);
  }
}
