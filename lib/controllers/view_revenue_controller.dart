// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'dart:developer';

import 'package:cinepass_admin/models/revenue_model.dart';
import 'package:cinepass_admin/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ViewRevenueController extends ChangeNotifier {
  int touchedIndex = 0;
  List<dynamic> allMonthsProfits = [];

  Future<RevenueModel> getAllValues() async {
    const storage = FlutterSecureStorage();
    final _token = await storage.read(key: 'token');
    final responseMonthly =
        await APIServices().getAPIWithToken('get-monthlySails', _token!);
    final statusMonthly =
        jsonDecode(responseMonthly.body) as Map<String, dynamic>;
    DateTime now = DateTime.now();
    int currentmonth = int.parse(now.toString().substring(5, 7));
    currentmonth = currentmonth - 1;
    dynamic allMonthsList = statusMonthly['data'];
    log(allMonthsList.toString());
    // allMonthsProfits = [...allMonthsList];
    allMonthsProfits.clear();
    for (dynamic element in allMonthsList) {
      allMonthsProfits.add(element);
    }
    int monthlySale = allMonthsList[currentmonth].toInt();

    final responseDaily =
        await APIServices().getAPIWithToken('get-dailySails', _token);
    final statusDaily = jsonDecode(responseDaily.body) as Map<String, dynamic>;
    dynamic dailySale = statusDaily['data']['total'].toInt().toString();
    int userCount = statusDaily['data']['userCount'];
    int ownerCount = statusDaily['data']['ownerCount'];
    int movieCount = statusDaily['data']['movieCount'];

    final responseBookedandCancelled =
        await APIServices().getAPIWithToken('get-status', _token);
    final bookedAndCancelledStatus =
        jsonDecode(responseBookedandCancelled.body) as Map<String, dynamic>;
    log(bookedAndCancelledStatus.toString());
    int booked = bookedAndCancelledStatus['data'][0];
    int cancelled = bookedAndCancelledStatus['data'][1];

    dynamic yearlySale = 0;
    for (dynamic month in allMonthsList) {
      yearlySale = yearlySale + month;
    }

    return RevenueModel(
        int.parse(dailySale),
        monthlySale,
        int.parse(yearlySale.toInt().toString()),
        int.parse(yearlySale.toInt().toString()),
        userCount,
        ownerCount,
        movieCount,
        booked,
        cancelled);
  }

  void changeTouchedIndex(int index) {
    touchedIndex = index;
    notifyListeners();
  }
}
