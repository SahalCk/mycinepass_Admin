// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:cinepass_admin/models/user_model.dart';
import 'package:cinepass_admin/services/api_services.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_snack_bars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ManageUsersController extends ChangeNotifier {
  List<UserModel> users = [];
  List<UserModel> searchedUsersList = [];

  Future<void> getAllUsers() async {
    searchedUsersList.clear();
    const storage = FlutterSecureStorage();
    final _token = await storage.read(key: 'token');
    final response = await APIServices().getAPIWithToken('adminuser', _token!);
    final status = jsonDecode(response.body) as Map<String, dynamic>;
    users = List<UserModel>.from(status['data'].map((e) {
      UserModel userModel = UserModel.fromJson(e);
      searchedUsersList.add(userModel);
      return userModel;
    }));
    notifyListeners();
  }

  void searchUser(String query) {
    searchedUsersList.clear();
    for (UserModel userModel in users) {
      if (userModel.signName.toLowerCase().contains(query.toLowerCase())) {
        searchedUsersList.add(userModel);
      }
      notifyListeners();
    }
  }

  Future<void> blockUser(BuildContext context, String userID) async {
    try {
      const storage = FlutterSecureStorage();
      final _token = await storage.read(key: 'token');
      final response = await APIServices()
          .postAPIWithToken('block-user', _token!, {"userId": userID});
      log(response.body);
      await getAllUsers();
      Navigator.of(context).pop();
      successSnackBar(context, 'Blocked User Successfully!');
    } catch (e) {
      Navigator.of(context).pop();
      errorSnackBar(context, e.toString());
    }
  }

  Future<void> unblockUser(BuildContext context, String userID) async {
    try {
      const storage = FlutterSecureStorage();
      final _token = await storage.read(key: 'token');
      final response = await APIServices()
          .postAPIWithToken('unblock-user', _token!, {"userId": userID});
      log(response.body);
      await getAllUsers();
      Navigator.of(context).pop();
      successSnackBar(context, 'Unblocked User Successfully!');
    } catch (e) {
      Navigator.of(context).pop();
      errorSnackBar(context, e.toString());
    }
  }
}
