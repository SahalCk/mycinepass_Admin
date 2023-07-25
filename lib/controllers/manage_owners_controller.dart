// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:cinepass_admin/models/owner_model.dart';
import 'package:cinepass_admin/services/api_services.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_snack_bars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ManageOwnersController extends ChangeNotifier {
  List<OwnerModel> allOwnersList = [];
  List<OwnerModel> searchedOwnerList = [];

  Future<void> getAllOwners(BuildContext context) async {
    searchedOwnerList.clear();
    try {
      const storage = FlutterSecureStorage();
      final _token = await storage.read(key: 'token');
      final response =
          await APIServices().getAPIWithToken('adminowner', _token!);
      final status = jsonDecode(response.body) as Map<String, dynamic>;
      allOwnersList = List<OwnerModel>.from(status['data'].map((e) {
        OwnerModel ownerModel = OwnerModel.fromJson(e);
        searchedOwnerList.add(ownerModel);
        return ownerModel;
      }));
      notifyListeners();
    } catch (e) {
      errorSnackBar(context, e.toString());
    }
  }

  void searchTheater(String query) {
    searchedOwnerList.clear();
    for (OwnerModel ownerModel in allOwnersList) {
      if (ownerModel.name.toLowerCase().contains(query.toLowerCase())) {
        searchedOwnerList.add(ownerModel);
      }
    }
    notifyListeners();
  }

  Future<void> blockOwner(BuildContext context, String ownerId) async {
    try {
      const storage = FlutterSecureStorage();
      final _token = await storage.read(key: 'token');
      final response = await APIServices()
          .postAPIWithToken('blockOwner', _token!, {"ownerId": ownerId});
      final status = jsonDecode(response.body) as Map<String, dynamic>;
      if (status['message'] == 'Owner blocked Successfully') {
        log(response.body);
        await getAllOwners(context);
        Navigator.of(context).pop();
        successSnackBar(context, 'Blocked Owner Successfully');
      } else {
        errorSnackBar(context, 'Something went wrong');
      }
    } catch (e) {
      errorSnackBar(context, e.toString());
    }
  }

  Future<void> unblockOwner(BuildContext context, String ownerId) async {
    try {
      const storage = FlutterSecureStorage();
      final _token = await storage.read(key: 'token');
      final response = await APIServices()
          .postAPIWithToken('unblockOwner', _token!, {"ownerId": ownerId});
      final status = jsonDecode(response.body) as Map<String, dynamic>;
      if (status['message'] == 'Owner unblocked successfully') {
        log(response.body);
        await getAllOwners(context);
        Navigator.of(context).pop();
        successSnackBar(context, 'Unblocked Owner Successfully');
      } else {
        errorSnackBar(context, 'Something went wrong');
      }
    } catch (e) {
      errorSnackBar(context, e.toString());
    }
  }

  Future<void> approveOwner(BuildContext context, String ownerId) async {
    try {
      const storage = FlutterSecureStorage();
      final _token = await storage.read(key: 'token');
      final response = await APIServices()
          .postAPIWithToken('ownerApprove', _token!, {"ownerId": ownerId});
      log(response.body);
      final status = jsonDecode(response.body) as Map<String, dynamic>;
      if (status['message'] == "Status Changed Successfully") {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        await getAllOwners(context);
        successSnackBar(context, 'Approved Owner Successfully');
      }
    } catch (e) {
      Navigator.of(context).pop();
      errorSnackBar(context, e.toString());
    }
  }

  Future<void> denieOwner(BuildContext context, String ownerId) async {
    try {
      const storage = FlutterSecureStorage();
      final _token = await storage.read(key: 'token');
      final response = await APIServices()
          .postAPIWithToken('ownerDenied', _token!, {"ownerId": ownerId});
      log(response.body);
      final status = jsonDecode(response.body) as Map<String, dynamic>;
      if (status['message'] == "Status Changed Successfully") {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        await getAllOwners(context);
        successSnackBar(context, 'Denied Owner Successfully');
      }
    } catch (e) {
      Navigator.of(context).pop();
      errorSnackBar(context, e.toString());
    }
  }
}
