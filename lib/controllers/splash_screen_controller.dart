// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:cinepass_admin/views/screens/screen_admin_login.dart';
import 'package:cinepass_admin/views/screens/screen_admin_panel.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_snack_bars.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenController extends ChangeNotifier {
  late StreamSubscription subscription;
  var isDeviceConnected = false;

  Future<void> getIsAlreadyLoggedIn(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final status = sharedPreferences.getBool('isAlreadyLogged');

    if (status == null) {
      await sharedPreferences.setBool('isAlreadyLogged', false);
    }

    if (status == false) {
      await Future.delayed(const Duration(seconds: 3));
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AdminLoginScreen()));
    } else {
      await Future.delayed(const Duration(seconds: 3));
      try {
        final LocalAuthentication auth = LocalAuthentication();

        final List<BiometricType> availableBiometrics =
            await auth.getAvailableBiometrics();

        if (availableBiometrics.isNotEmpty) {
          final bool authenticated = await auth.authenticate(
              localizedReason: 'Authenticate to Login',
              options: const AuthenticationOptions(
                  stickyAuth: true,
                  sensitiveTransaction: true,
                  biometricOnly: false));

          if (authenticated) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const AdminPanelScreen()));
          } else {
            errorSnackBar(context, 'Authentication Failed !');
          }
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const AdminPanelScreen()));
        }
      } catch (e) {
        errorSnackBar(context, e.toString());
      }
    }
  }
}
