import 'dart:convert';

MovieModel movieModelFromJson(String str) =>
    MovieModel.fromJson(json.decode(str));

String movieModelToJson(MovieModel data) => json.encode(data.toJson());

class MovieModel {
  String id;
  int movieId;
  String title;
  String language;
  DateTime releaseDate;
  String image;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  MovieModel({
    required this.id,
    required this.movieId,
    required this.title,
    required this.language,
    required this.releaseDate,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
        id: json["_id"],
        movieId: json["movieId"],
        title: json["title"],
        language: json["language"],
        releaseDate: DateTime.parse(json["releaseDate"]),
        image: json["image"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "movieId": movieId,
        "title": title,
        "language": language,
        "releaseDate":
            "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "image": image,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}
