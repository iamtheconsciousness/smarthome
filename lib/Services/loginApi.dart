import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../Models/loginModel.dart';

class LoginRequestService {
  final String baseUrl;

  LoginRequestService(this.baseUrl);

  Future<http.Response> post(
      String endpoint, Map<String, dynamic> body,
      {String contentType = 'application/json'}) async {
    final response = await http.post(Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': contentType},
      body: jsonEncode(body),
    );

    if(response.statusCode == 200){
      ReadLogin tempResponse = myStructFromJson(response.body);
      final String? accessToken = tempResponse.access;
      final String? refreshToken = tempResponse.refresh;
      final storage = FlutterSecureStorage();
      storage.write(key: 'accessToken', value: accessToken);
      storage.write(key: 'refreshToken', value: refreshToken);


    }
    return response;
  }
}