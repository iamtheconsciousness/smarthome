import 'package:http/http.dart' as http;
import 'structure_model.dart';

class struct_services{

  static Future<List<Led>?> getAccess(String url) async{
    final response =await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final  myStruct= myStructFromJson(response.body) ;
      return myStruct.led;

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}