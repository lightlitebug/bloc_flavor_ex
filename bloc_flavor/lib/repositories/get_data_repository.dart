import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GetDataRepository {
  final http.Client httpClient;

  GetDataRepository({@required this.httpClient}) : assert(httpClient != null);

  Future<String> getData(String dataUrl, String token) async {
    final http.Response response = await httpClient.get(
      dataUrl,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final String message = responseData['message'];

      return message;
    }

    final errorBody = json.decode(response.body);
    print(
        'Request failed: statusCode: ${response.statusCode}\nreason: ${errorBody['errMessage']}');
    throw 'Request failed: statusCode: ${response.statusCode}\nreason: ${errorBody['errMessage']}';
  }
}
