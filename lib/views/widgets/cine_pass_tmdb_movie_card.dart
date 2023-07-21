import 'package:cinepass_admin/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TMDBMovieCard extends StatelessWidget {
  final int movieID;
  final String filmName;
  final String filmPoster;
  const TMDBMovieCard(
      {super.key,
      required this.movieID,
      required this.filmName,
      required this.filmPoster});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromRGBO(84, 168, 229, 0.1),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          SizedBox(
            height: Adaptive.h(25),
            width: Adaptive.h(100),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              child: Image.network(
                'https://image.tmdb.org/t/p/w500/$filmPoster',
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  return child;
                },
                loadingBuilder: (context, child, loadingProgress) {
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
                },
                fit: BoxFit.fill,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Adaptive.w(1.5)),
                child: Text(filmName,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        const TextStyle(color: Colors.white, fontSize: 15.5)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
