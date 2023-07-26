import 'package:cinepass_admin/controllers/manage_movies_controller.dart';
import 'package:cinepass_admin/utils/colors.dart';
import 'package:cinepass_admin/utils/sized_boxes.dart';
import 'package:cinepass_admin/views/screens/movies_section/screen_add_movie.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_appbar.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_floating_action_button.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_movie_card.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ManageMoviesScreen extends StatelessWidget {
  const ManageMoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchCinemaController = TextEditingController();
    final movieController =
        Provider.of<ManageMoviesController>(context, listen: false);
    movieController.getAllMovies();
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: backgroundColor),
        child: Scaffold(
          appBar: CinePassAppBar()
              .cinePassAppBar(context: context, title: 'Manage Movies'),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: Adaptive.w(4)),
            child: Column(
              children: [
                sizedBoxHeight20,
                CinePassSearchField(
                  controller: searchCinemaController,
                  function: (searchCinemaController) =>
                      movieController.searchMovies(searchCinemaController),
                  clearingFunction: () {
                    searchCinemaController.clear();
                    movieController.searchMovies('');
                  },
                  hint: 'Search Movie',
                ),
                sizedBoxHeight30,
                Consumer<ManageMoviesController>(
                  builder: (context, value, child) {
                    return value.searchedMovies.isNotEmpty
                        ? Expanded(
                            child: ListView.separated(
                                padding: EdgeInsets.only(bottom: Adaptive.h(1)),
                                itemBuilder: (context, index) {
                                  return CinePassMoviecard(
                                      id: value.searchedMovies[index].id,
                                      moviePoster:
                                          value.searchedMovies[index].image,
                                      movieName:
                                          value.searchedMovies[index].title,
                                      movieID: value
                                          .searchedMovies[index].movieId
                                          .toString(),
                                      movieLanguage:
                                          value.searchedMovies[index].language,
                                      movieReleaseDate: value
                                          .searchedMovies[index].releaseDate
                                          .toString());
                                },
                                separatorBuilder: (context, index) {
                                  return sizedBoxHeight10;
                                },
                                itemCount: value.searchedMovies.length),
                          )
                        : Expanded(
                            child: Center(
                              child: CircularProgressIndicator(
                                  backgroundColor:
                                      const Color.fromARGB(255, 207, 234, 255),
                                  color: primaryColor,
                                  strokeWidth: 6),
                            ),
                          );
                  },
                )
              ],
            ),
          ),
          floatingActionButton: CinePassFloatingActionButton(
              function: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddMovieScreen()));
              },
              text: 'Add New Movie'),
        ));
  }
}
