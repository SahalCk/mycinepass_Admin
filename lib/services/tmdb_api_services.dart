import 'package:cinepass_admin/services/api_keys.dart';
import 'package:http/http.dart';

class TMDBAPIServices {
  final String baseUrl = 'https://api.themoviedb.org/3/search/movie?query=';

  Future<Response> tmdbAPIGet(String query) async {
    final respose = await get(Uri.parse(baseUrl + query), headers: {
      'Authorization': 'Bearer $tmdbToken',
      'accept': 'application/json'
    });
    return respose;
  }
}
