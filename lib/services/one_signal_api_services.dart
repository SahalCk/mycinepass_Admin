import 'dart:convert';

import 'package:cinepass_admin/services/api_keys.dart';
import 'package:http/http.dart';

class OneSignalAPIServices {
  String baseUrl = 'https://onesignal.com/api/v1/notifications';

  Future<Response> movieAddedPushNotification(
      String movieName, String imagePath) async {
    final response = await post(Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Basic $oneSignalAPIKey',
          'accept': 'application/json'
        },
        body: jsonEncode({
          'app_id': oneSignalAppId,
          'included_segments': ['All'],
          'contents': {'en': '$movieName is Added'},
          'headings': {'en': 'New Movie Added'},
          'big_picture': 'https://image.tmdb.org/t/p/w500/$imagePath'
        }));
    return response;
  }
}
