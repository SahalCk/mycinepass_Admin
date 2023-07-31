import 'dart:developer';

import 'package:cinepass_admin/controllers/splash_screen_controller.dart';
import 'package:cinepass_admin/utils/colors.dart';
import 'package:cinepass_admin/utils/sized_boxes.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gif_view/gif_view.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          SystemUiOverlayStyle.light.copyWith(statusBarColor: backgroundColor),
      child: Scaffold(
        body: StreamBuilder<ConnectivityResult>(
          stream: Connectivity().onConnectivityChanged,
          builder: (context, snapshot) {
            log(snapshot.data.toString());
            if (snapshot.data != ConnectivityResult.none &&
                snapshot.data != null) {
              final splashScreenProvider =
                  Provider.of<SplashScreenController>(context, listen: false);
              splashScreenProvider.getIsAlreadyLoggedIn(context);
              return Container(
                width: Adaptive.w(100),
                height: Adaptive.h(100),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                      backgroundColor,
                      backgroundColor,
                      const Color.fromARGB(255, 29, 35, 46)
                    ])),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    GifView.asset(
                      'animations/splash_screen_animation.gif',
                      loop: false,
                      height: Adaptive.h(25),
                      width: Adaptive.w(65),
                    ),
                    Column(
                      children: [
                        Text('Admin App',
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        sizedBoxHeight10
                      ],
                    )
                  ],
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LottieBuilder.asset(
                      'animations/connection_lost.json',
                      width: Adaptive.w(90),
                    ),
                    const Text('No Internet Connection!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromARGB(255, 238, 238, 238),
                            fontSize: 17,
                            fontWeight: FontWeight.bold)),
                    const Text('Please Check Your Internet Connection',
                        style: TextStyle(
                            color: Color.fromARGB(255, 158, 158, 158),
                            fontSize: 13))
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
