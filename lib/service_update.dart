import 'package:http/http.dart' as http;
import 'update_model.dart';

class update_services{

  static Future<Update> getAccess(String url) async{
    final response =await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final  Update update= updateFromJson(response.body);
      return update;

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}