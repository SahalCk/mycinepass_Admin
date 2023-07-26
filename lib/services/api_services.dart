import 'dart:convert';
import 'package:http/http.dart' as http;

class APIServices {
  final String baseUrl = 'https://bookmyscreen.onrender.com/admin/';

  Future<http.Response> postAPI(String url, dynamic body) async {
    final http.Response response = await http.post(Uri.parse(baseUrl + url),
        headers: {
          'Content-type': 'application/json;charset=utf-8',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
        encoding: Encoding.getByName('utf-8'));
    return response;
  }

  Future<http.Response> getAPIWithToken(String url, String token) async {
    final response = await http.get(Uri.parse(baseUrl + url), headers: {
      'Content-type': 'application/json;charset=utf-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    return response;
  }

  Future<http.Response> postAPIWithToken(
      String url, String token, dynamic body) async {
    final response = await http.post(Uri.parse(baseUrl + url),
        headers: {
          'Content-type': 'application/json;charset=utf-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(body),
        encoding: Encoding.getByName('utf-8'));
    return response;
  }
}
