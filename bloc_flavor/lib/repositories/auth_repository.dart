import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final http.Client httpClient;

  AuthRepository({@required this.httpClient}) : assert(httpClient != null);

  Future<String> login(String baseUrl) async {
    print('baseUrl: $baseUrl');
    await Future.delayed(Duration(seconds: 1));

    final http.Response response = await httpClient.get('$baseUrl/login');

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final String token = responseBody['token'];

      return token;
    }

    final errorBody = json.decode(response.body);
    print(
        'Request failed: statusCode: ${response.statusCode}\nreason: ${errorBody['errMessage']}');
    throw 'Request failed: statusCode: ${response.statusCode}\nreason: ${errorBody['errMessage']}';
  }

  Future<void> persistToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwtToken', token);
  }

  Future<void> deleteToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwtToken');
  }

  Future<bool> hasToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('jwtToken');
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwtToken');
  }
}
