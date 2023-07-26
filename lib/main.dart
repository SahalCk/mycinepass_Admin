import 'package:cinepass_admin/controllers/login_screen_controller.dart';
import 'package:cinepass_admin/controllers/manage_banner_controller.dart';
import 'package:cinepass_admin/controllers/manage_coupons_controller.dart';
import 'package:cinepass_admin/controllers/manage_movies_controller.dart';
import 'package:cinepass_admin/controllers/manage_owners_controller.dart';
import 'package:cinepass_admin/controllers/manage_users_controller.dart';
import 'package:cinepass_admin/controllers/view_revenue_controller.dart';
import 'package:cinepass_admin/controllers/splash_screen_controller.dart';
import 'package:cinepass_admin/controllers/view_bookings_controller.dart';
import 'package:cinepass_admin/firebase_options.dart';
import 'package:cinepass_admin/utils/colors.dart';
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
                create: (context) => ManageBannerController()),
            ChangeNotifierProvider(
                create: (context) => ManageMoviesController()),
            ChangeNotifierProvider(
                create: (context) => ManageUsersController()),
            ChangeNotifierProvider(
                create: (context) => ManageOwnersController()),
            ChangeNotifierProvider(
                create: (context) => ViewBookingsController()),
            ChangeNotifierProvider(
                create: (context) => ViewRevenueController()),
            ChangeNotifierProvider(
                create: (context) => ManageCouponsController())
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
