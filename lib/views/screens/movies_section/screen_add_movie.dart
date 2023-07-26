// ignore_for_file: use_build_context_synchronously

import 'package:cinepass_admin/controllers/manage_movies_controller.dart';
import 'package:cinepass_admin/utils/colors.dart';
import 'package:cinepass_admin/utils/sized_boxes.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_appbar.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_loading.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_search_field.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_tmdb_movie_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddMovieScreen extends StatelessWidget {
  AddMovieScreen({super.key});

  final searchCinemaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final movieController =
        Provider.of<ManageMoviesController>(context, listen: false);
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: backgroundColor),
        child: Scaffold(
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
                                  return InkWell(
                                    onTap: () async {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            title: Text(
                                              'Are you sure you want to Add ${value.tmdbSearchedList[index].title}?',
                                              style: const TextStyle(
                                                  color: Colors.white),
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
                                                    await movieController.addMovie(
                                                        context,
                                                        movieController
                                                                .tmdbSearchedList[
                                                            index]);
                                                    Navigator.of(context).pop();
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
                                    child: TMDBMovieCard(
                                        movieID:
                                            value.tmdbSearchedList[index].id,
                                        filmName:
                                            value.tmdbSearchedList[index].title,
                                        filmPoster: value
                                            .tmdbSearchedList[index]
                                            .posterPath),
                                  );
                                },
                                itemCount: value.tmdbSearchedList.length,
                              )
                            : const Center(
                                child: Text(
                                  'Please Search Movie',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              );
                      },
                    );
                  },
                ))
              ],
            ),
          ),
        ));
  }
}
