import 'dart:convert';
import 'dart:developer';

import 'package:cinepass_admin/services/api_services.dart';
import 'package:cinepass_admin/views/screens/screen_admin_panel.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_snack_bars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreenController extends ChangeNotifier {
  bool obscureValue = true;

  void changeObscure() {
    if (obscureValue == false) {
      obscureValue = true;
      notifyListeners();
    } else {
      obscureValue = false;
      notifyListeners();
    }
  }

  Future<void> signinButtonClicked(
      BuildContext context, String email, String password) async {
    try {
      final response = await APIServices()
          .postAPI('adminlogin', {"password": password, "email": email});
      final status = jsonDecode(response.body) as Map<String, dynamic>;

      log(status.toString());
      if (status['message'] == 'Wrong email Id') {
        Navigator.of(context).pop();
        errorSnackBar(context, 'Wrong Email');
      } else if (status['message'] == 'Wrong password') {
        Navigator.of(context).pop();
        errorSnackBar(context, 'Wrong Password');
      } else if (status['message'] == 'correct password') {
        const storage = FlutterSecureStorage();
        await storage.write(key: 'token', value: status['token']);
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.setBool('isAlreadyLogged', true);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const AdminPanelScreen()),
            (route) => false);
      }
    } catch (e) {
      Navigator.of(context).pop();
      errorSnackBar(context, e.toString());
    }
  }
}
