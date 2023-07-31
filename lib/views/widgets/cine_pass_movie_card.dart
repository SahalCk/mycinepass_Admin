import 'package:cinepass_admin/controllers/manage_movies_controller.dart';
import 'package:cinepass_admin/utils/colors.dart';
import 'package:cinepass_admin/utils/sized_boxes.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CinePassMoviecard extends StatelessWidget {
  final String id;
  final String moviePoster;
  final String movieName;
  final String movieID;
  final String movieLanguage;
  final String movieReleaseDate;
  const CinePassMoviecard(
      {super.key,
      required this.id,
      required this.moviePoster,
      required this.movieName,
      required this.movieID,
      required this.movieLanguage,
      required this.movieReleaseDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Adaptive.h(1.3)),
      height: Adaptive.h(22),
      width: Adaptive.w(100),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(84, 168, 229, 0.1),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          SizedBox(
            height: Adaptive.h(100),
            width: Adaptive.w(27),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                  'https://image.tmdb.org/t/p/w500/$moviePoster', frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                return child;
              }, loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                        backgroundColor:
                            const Color.fromARGB(255, 207, 234, 255),
                        color: primaryColor,
                        strokeWidth: 6),
                  );
                }
              }, fit: BoxFit.fill),
            ),
          ),
          SizedBox(width: Adaptive.w(4)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: Adaptive.w(55),
                child: Text(movieName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
              Text(movieID,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
              Text(movieLanguageAlter(movieLanguage),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.blue, fontSize: 16)),
              SizedBox(
                width: Adaptive.w(55),
                child: Text(movieReleaseDate.substring(0, 10),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
              ),
              sizedBoxHeight20,
              SizedBox(
                height: Adaptive.h(4.5),
                child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            title: Text(
                              'Are you sure you want to delete $movieName?',
                              style: const TextStyle(color: Colors.white),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return const CinePassLoading();
                                      },
                                    );

                                    await Provider.of<ManageMoviesController>(
                                            context,
                                            listen: false)
                                        .deleteMovie(context, id);
                                  },
                                  child: const Text('Yes')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('No'))
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          )
        ],
      ),
    );
  }

  String movieLanguageAlter(String movieLang) {
    if (movieLanguage == 'en') {
      return 'English';
    } else if (movieLanguage == 'ml') {
      return 'Malayalam';
    } else if (movieLanguage == 'fr') {
      return 'French';
    } else if (movieLanguage == 'pl') {
      return 'Polish';
    } else if (movieLanguage == 'hi') {
      return 'Hindi';
    } else {
      return movieLang;
    }
  }
}
