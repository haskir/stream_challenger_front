// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stream_challenge/core/error/exception.dart';
import 'package:stream_challenge/feature/data/models/user.dart';

class UserRequester {
  final http.Client client;
  final String address = "api.localhost";

  UserRequester({required this.client});

  Future<List<User>> getAllPersons(int page) => _getPersonFromUrl("");
  Future<List<User>> searchPerson(String query) => _getPersonFromUrl("");

  Future<List<User>> _getPersonFromUrl(String url) async {
    print(url);
    final response = await client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final users = json.decode(response.body);
      return (users['results'] as List)
          .map((user) => User.fromJson(user))
          .toList();
    } else {
      throw ServerException();
    }
  }
}
