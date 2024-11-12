import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:stream_challenge/core/error/failure.dart';
import 'package:stream_challenge/providers.dart';

abstract class _Client {
  Future<Either<Failure, Map<String, dynamic>>> get(
    String url, [
    Map<String, dynamic> params = const {},
  ]);

  Future<Either<Failure, bool>> post(String url, Map<String, dynamic> body);

  Future<Either<Failure, bool>> delete(String url);

  Future<Either<Failure, bool>> put(String url, Map<String, dynamic> body);
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
      _dio.interceptors.add(LogInterceptor(
        request: true,
        requestBody: true, // Печать тела запроса
        responseBody: true, // Печать тела ответа
      ));
    }
  }

  Failure _processResponse(Response response) {
    Map<int, Failure> failures = {
      401: AuthFailure(),
      403: UserFailure(),
      404: NotFoundFailure(),
      500: ServerFailure(),
    };
    return failures[response.statusCode] ?? UnknownFailure();
  }

  Future<Either<Failure, T>> _request<T>(
    String method,
    String url, {
    Map<String, dynamic> params = const {},
    Map<String, dynamic> body = const {},
    T Function(dynamic data)? parser,
  }) async {
    try {
      final response = await _dio.request(
        url,
        data: body,
        queryParameters: params,
        options: Options(method: method),
      );
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
      if (e.response != null) {
        return Left(_processResponse(e.response!));
      } else {
        return Left(UnknownFailure());
      }
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> get(
    String url, [
    Map<String, dynamic> params = const {},
  ]) {
    return _request<Map<String, dynamic>>(
      'GET',
      url,
      params: params,
      parser: (data) => Map<String, dynamic>.from(data),
    );
  }

  @override
  Future<Either<Failure, bool>> post(String url, Map<String, dynamic> body) {
    return _request<bool>(
      'POST',
      url,
      body: body,
    );
  }

  @override
  Future<Either<Failure, bool>> put(String url, Map<String, dynamic> body) {
    return _request<bool>(
      'PUT',
      url,
      body: body,
    );
  }

  @override
  Future<Either<Failure, bool>> delete(String url) {
    return _request<bool>(
      'DELETE',
      url,
    );
  }
}
