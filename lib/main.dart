import 'package:cinepass_admin/controllers/login_screen_controller.dart';
import 'package:cinepass_admin/controllers/manage_banner_controller.dart';
import 'package:cinepass_admin/controllers/splash_screen_controller.dart';
import 'package:cinepass_admin/firebase_options.dart';
import 'package:cinepass_admin/utils/colors.dart';
import 'package:cinepass_admin/views/screens/banner_section/screen_manage_banners.dart';
import 'package:cinepass_admin/views/screens/screen_splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
                create: (context) => SplashScreenController()),
            ChangeNotifierProvider(
                create: (context) => LoginScreenController()),
            ChangeNotifierProvider(
                create: (context) => ManageBannerController())
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'My CinePass',
            theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                    seedColor: primaryColor,
                    primary: primaryColor,
                    background: backgroundColor),
                useMaterial3: true,
                fontFamily: 'Poppins'),
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
