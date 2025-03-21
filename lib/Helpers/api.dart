import 'dart:convert';

import 'package:http/http.dart' as http;
class Api{
  Future<dynamic> get({
    required url,
    required headers,
})async{
    http.Response response = await http.get(Uri.parse(url) ,headers: headers);
    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }else{
      throw Exception('There is a problem with status code ${response.statusCode}');
    }
  }
}
