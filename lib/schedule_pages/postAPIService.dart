import 'dart:convert';
import 'package:http/http.dart' as http;

class PostRequestService {
  final String baseUrl;

  PostRequestService(this.baseUrl);

  Future<http.Response> post(
      String endpoint, Map<String, dynamic> body,
      {String contentType = 'application/json'}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': contentType},
      body: jsonEncode(body),
    );

    return response;
  }
}