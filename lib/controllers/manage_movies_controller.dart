// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:cinepass_admin/models/debouncer_model.dart';
import 'package:cinepass_admin/models/movie_model.dart';
import 'package:cinepass_admin/models/movie_tmdb_model.dart';
import 'package:cinepass_admin/services/api_services.dart';
import 'package:cinepass_admin/services/one_signal_api_services.dart';
import 'package:cinepass_admin/services/tmdb_api_services.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_snack_bars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ManageMoviesController extends ChangeNotifier {
  List<MovieModel> allAvailableMovies = [];
  List<MovieModel> searchedMovies = [];
  List<Result> tmdbSearchedList = [];

  Future<void> getAllMovies() async {
    try {
      const storage = FlutterSecureStorage();
      // ignore: no_leading_underscores_for_local_identifiers
      final _token = await storage.read(key: 'token');
      final response =
          await APIServices().getAPIWithToken('getMovies', _token!);
      final status = jsonDecode(response.body) as Map<String, dynamic>;
      allAvailableMovies = List<MovieModel>.from(status['data'].map((item) {
        MovieModel model = MovieModel.fromJson(item);
        return model;
      }));
      searchedMovies = [...allAvailableMovies];
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deleteMovie(BuildContext context, String movieID) async {
    try {
      const storage = FlutterSecureStorage();
      // ignore: no_leading_underscores_for_local_identifiers
      final _token = await storage.read(key: 'token');
      final response = await APIServices()
          .postAPIWithToken('deleteMovie', _token!, {"movieId": movieID});
      final status = jsonDecode(response.body) as Map<String, dynamic>;
      if (status['message'] == 'Movie deleted successfully') {
        await getAllMovies();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        successSnackBar(context, 'Movie deleted Successfully!');
      } else {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        errorSnackBar(context, 'Something went wrong');
      }
    } catch (e) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      errorSnackBar(context, e.toString());
    }
  }

  void searchMovies(String query) {
    searchedMovies.clear();
    for (var model in allAvailableMovies) {
      if (model.title.toLowerCase().contains(query.toLowerCase())) {
        searchedMovies.add(model);
      }
    }
    notifyListeners();
  }

  Future<void> searchTMDBMovie(String query) async {
    try {
      final debouncer = Debouncer(milliseconds: 600);
      debouncer.run(() async {
        tmdbSearchedList.clear();
        final response = await TMDBAPIServices().tmdbAPIGet(query);
        final status = jsonDecode(response.body) as Map<String, dynamic>;
        final list = status["results"];
        for (var element in list) {
          final value = Result.fromJson(element);
          tmdbSearchedList.add(value);
          notifyListeners();
        }
        // List<Result>.from(status["results"].map((element) {
        //   Result movieTmdbModel = Result.fromJson(element);
        //   log(movieTmdbModel.title);
        //   tmdbSearchedList?.add(movieTmdbModel);
        //   log(tmdbSearchedList?.length.toString() ?? 'null');
        // }));
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> addMovie(BuildContext context, Result result) async {
    try {
      const storage = FlutterSecureStorage();
      // ignore: no_leading_underscores_for_local_identifiers
      final _token = await storage.read(key: 'token');
      log(result.releaseDate.toIso8601String());
      final response =
          await APIServices().postAPIWithToken('add-movies', _token!, {
        "movieDetails": {
          "id": result.id,
          "title": result.title,
          "original_language": result.originalLanguage,
          "release_date": result.releaseDate.toString().substring(0, 10),
          "poster_path": result.posterPath
        }
      });
      final status = jsonDecode(response.body) as Map<String, dynamic>;
      if (status['message'] == 'Movie Added') {
        final response = await OneSignalAPIServices()
            .movieAddedPushNotification(result.title, result.posterPath);
        final status = jsonDecode(response.body) as Map<String, dynamic>;
        log(status.toString());
        await getAllMovies();
        Navigator.of(context).pop();
        successSnackBar(context, 'Movie Added Successfully!');
      } else if (status['message'] == 'Movie already added') {
        Navigator.of(context).pop();
        errorSnackBar(context, 'Movie is already Added');
      } else {
        Navigator.of(context).pop();
        errorSnackBar(context, 'Something went wrong');
      }
    } catch (e) {
      Navigator.of(context).pop();
      errorSnackBar(context, e.toString());
    }
  }
}
