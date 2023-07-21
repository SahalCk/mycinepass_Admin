import 'package:cinepass_admin/controllers/manage_movies_controller.dart';
import 'package:cinepass_admin/utils/sized_boxes.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_appbar.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_search_field.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_tmdb_movie_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddMovieScreen extends StatelessWidget {
  AddMovieScreen({super.key});

  final searchCinemaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final movieController =
        Provider.of<ManageMoviesController>(context, listen: false);
    return Scaffold(
      appBar: CinePassAppBar()
          .cinePassAppBar(context: context, title: 'Add New Movie'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Adaptive.w(4)),
        child: Column(
          children: [
            sizedBoxHeight20,
            CinePassSearchField(
              controller: searchCinemaController,
              function: (searchCinemaController) =>
                  movieController.searchTMDBMovie(searchCinemaController),
              clearingFunction: () {
                searchCinemaController.clear();
                // movieController.searchMovies('');
              },
              hint: 'Search Movie',
            ),
            sizedBoxHeight30,
            Expanded(child: Consumer<ManageMoviesController>(
              builder: (context, value, child) {
                return Consumer<ManageMoviesController>(
                  builder: (context, value, child) {
                    return value.tmdbSearchedList.isNotEmpty
                        ? GridView.builder(
                            padding: EdgeInsets.only(bottom: Adaptive.h(2)),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: Adaptive.h(1.2),
                                    crossAxisSpacing: Adaptive.w(2.5),
                                    childAspectRatio: 0.7,
                                    crossAxisCount: 2),
                            itemBuilder: (context, index) {
                              return TMDBMovieCard(
                                  movieID: value.tmdbSearchedList[index].id,
                                  filmName: value.tmdbSearchedList[index].title,
                                  filmPoster:
                                      value.tmdbSearchedList[index].posterPath);
                            },
                            itemCount: value.tmdbSearchedList.length,
                          )
                        : const Center(
                            child: Text(
                              'Please Search Movie',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          );
                  },
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
