import 'package:cinepass_admin/controllers/splash_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final splashScreenProvider =
        Provider.of<SplashScreenController>(context, listen: false);
    splashScreenProvider.getIsAlreadyLoggedIn(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: GifView.asset(
              'animations/splash_screen_animation.gif',
              loop: false,
              height: Adaptive.h(25),
              width: Adaptive.w(65),
            ),
          )
        ],
      ),
    );
  }
}
