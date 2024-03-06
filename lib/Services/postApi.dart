import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class PostRequestService {
  final String baseUrl;
  final storage = FlutterSecureStorage();
  PostRequestService(this.baseUrl);

  Future<http.Response> post(
      String endpoint, Map<String, dynamic> body,
      {String contentType = 'application/json'
      }) async {
    final response = await http.post(Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': contentType,
        'Authorization': 'Bearer '
      },
      body: jsonEncode(body),
    );

    return response;
  }
}