import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stream_challenge/core/error/failure.dart';

abstract class _Client {
  Either<Future<bool>, Failure> post(String url, Map<String, dynamic> body);
  Either<Future<Map>, Failure> get(String url, Map<String, dynamic> params);
  Either<Future<bool>, Failure> delete(String url);
  Either<Future<bool>, Failure> put(String url, Map<String, dynamic> body);
}

class Requester implements _Client {
  final Dio _dio = Dio();
  late Map<String, String> _headers;
  String token;

  Requester({
    required this.token,
  }) {
    _headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Failure _proccessResponse(Response response) {
    Map<int, Failure> failures = {
      401: AuthFailure(),
      404: NotFoundFailure(),
      403: UserFailure(),
      500: ServerFailure(),
    };
    return failures[response.statusCode] ?? UnknownFailure();
  }

  @override
  get(String url, Map<String, dynamic> params) async {
    final response = await _dio.get(
      url,
      queryParameters: params,
      options: Options(headers: _headers, responseType: ResponseType.json),
    );
    if (response.statusCode == 200) {
      return right(response.data);
    }
    return left(_proccessResponse(response));
  }

  @override
  post(String url, Map<String, dynamic> body) async {
    final response = await _dio.post(url,
        data: body,
        options: Options(headers: _headers, responseType: ResponseType.json));
    if (response.statusCode == 200) {
      return right(response.data);
    }
    return left(_proccessResponse(response));
  }

  @override
  put(String url, Map<String, dynamic> body) async {
    final response = await _dio.put(url,
        data: body,
        options: Options(headers: _headers, responseType: ResponseType.json));
    if (response.statusCode == 200) {
      return right(response.data);
    }
    return left(_proccessResponse(response));
  }

  @override
  delete(String url) async {
    final response = await _dio.delete(url,
        options: Options(headers: _headers, responseType: ResponseType.json));
    if (response.statusCode == 200) {
      return right(response.data);
    }
    return left(_proccessResponse(response));
  }
}
