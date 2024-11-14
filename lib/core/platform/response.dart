// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'datetime_format.dart';

class ErrorDTO {
  final int code;
  final String message;
  final String type;
  ErrorDTO({
    required this.code,
    required this.message,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'message': message,
      'type': type,
    };
  }

  factory ErrorDTO.fromMap(Map<String, dynamic> map) {
    return ErrorDTO(
      code: map['code'] as int,
      message: map['message'] as String,
      type: map['type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ErrorDTO.fromJson(String source) =>
      ErrorDTO.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => prettyJson(toMap());
}

class ResponseDTO {
  final bool success;
  final ErrorDTO? error;
  final dynamic data;

  ResponseDTO({
    required this.success,
    this.error,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'error': error?.toMap(),
      'data': data,
    };
  }

  factory ResponseDTO.fromMap(Map<String, dynamic> map) {
    return ResponseDTO(
      success: map['success'] as bool,
      error: map['error'] != null
          ? ErrorDTO.fromMap(map['error'] as Map<String, dynamic>)
          : null,
      data: map['data'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => prettyJson(toMap());

  factory ResponseDTO.fromJson(String source) =>
      ResponseDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
