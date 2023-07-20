// To parse this JSON data, do
//
//     final movieBannerModel = movieBannerModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

MovieBannerModel movieBannerModelFromJson(String str) =>
    MovieBannerModel.fromSnapshot(json.decode(str));

String movieBannerModelToJson(MovieBannerModel data) =>
    json.encode(data.toJson());

class MovieBannerModel {
  String bannerImageUrl;
  String movieDescription;
  String movieName;

  MovieBannerModel({
    required this.bannerImageUrl,
    required this.movieDescription,
    required this.movieName,
  });

  factory MovieBannerModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final data = documentSnapshot.data()!;
    return MovieBannerModel(
      bannerImageUrl: data["bannerImageUrl"],
      movieDescription: data["movieDescription"],
      movieName: data["movieName"],
    );
  }

  Map<String, dynamic> toJson() => {
        "bannerImageUrl": bannerImageUrl,
        "movieDescription": movieDescription,
        "movieName": movieName,
      };
}
