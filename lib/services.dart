import 'package:http/http.dart' as http;
import 'login_model.dart';

class services{

  static Future<MyLed> getAccess(String url) async{
    final response =await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print("url correct");
      final  MyLed myLed= myLedFromJson(response.body);
      return myLed;

    } else {
      print("url incorrect");

      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}