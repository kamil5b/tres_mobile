
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'global.dart';

class Network{
  
  
  var token;

  _getToken() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token')!)['token'];
  }

  post(data, apiURL) async{
    var fullUrl = urlipv4+'/api' + apiURL;
    return await http.post(
        Uri.parse(fullUrl),
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }

  getData(apiURL) async{
    var fullUrl = urlipv4+'/api' + apiURL;
    await _getToken();
    var data = await http.get(
      Uri.parse(fullUrl),
      headers: _setHeaders(),
    );
    return data;
  }

  _setHeaders() => {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
}