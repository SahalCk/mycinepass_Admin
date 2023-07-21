import 'package:cinepass_admin/controllers/manage_banner_controller.dart';
import 'package:cinepass_admin/utils/colors.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CinePassBanner extends StatelessWidget {
  final String movieName;
  final String movieDescription;
  final String imgUrl;
  final int index;
  const CinePassBanner(
      {super.key,
      required this.movieName,
      required this.movieDescription,
      required this.imgUrl,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Adaptive.h(32.3),
      width: Adaptive.w(100),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(84, 168, 229, 0.1),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          SizedBox(
            height: Adaptive.h(22),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                  child: Image.network(
                    imgUrl,
                    width: Adaptive.w(100),
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
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
                Positioned(
                  right: Adaptive.w(1.5),
                  top: Adaptive.w(1.2),
                  child: FloatingActionButton(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      mini: true,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              title: Text(
                                'Are you sure you want to delete $movieName Banner?',
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
                                      await Provider.of<ManageBannerController>(
                                              context,
                                              listen: false)
                                          .deleteData(context, index);
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
                      child: const Icon(
                        Icons.delete_rounded,
                        color: Colors.white,
                        size: 20,
                      )),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Adaptive.w(2.5), vertical: Adaptive.h(0.5)),
            child: Column(
              children: [
                SizedBox(
                  width: Adaptive.w(100),
                  height: Adaptive.h(3.5),
                  child: Text(
                    movieName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: Adaptive.w(100),
                  height: Adaptive.h(5),
                  child: Text(
                    movieDescription,
                    style: TextStyle(color: subTextColor),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
