// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'dart:developer';

import 'package:cinepass_admin/models/booking_model.dart';
import 'package:cinepass_admin/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ViewBookingsController extends ChangeNotifier {
  DateTime? fromDate;
  DateTime? toDate;
  List<MovieBookingModel> allBookingsList = [];
  List<MovieBookingModel> sortedList = [];

  Future<List<MovieBookingModel>?> getAllBookings() async {
    try {
      const storage = FlutterSecureStorage();
      final _token = await storage.read(key: 'token');
      List<MovieBookingModel> allBooking = [];
      final response =
          await APIServices().getAPIWithToken('get-allOrders', _token!);
      final status = jsonDecode(response.body) as Map<String, dynamic>;
      if (status['success'] == true) {
        allBooking = List<MovieBookingModel>.from(status['data'].map((e) {
          MovieBookingModel bookingModel = MovieBookingModel.fromJson(e);
          return bookingModel;
        }));
        allBookingsList = [...allBooking];
        return allBooking;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  void setSortedList() {
    sortedList.clear();
    for (var model in allBookingsList) {
      if (model.date.isAfter(fromDate!) && model.date.isBefore(toDate!)) {
        sortedList.add(model);
      }
    }
    notifyListeners();
  }

  void setFromDate(DateTime? fromDatef) {
    fromDate = fromDatef;
    notifyListeners();
  }

  void setToDate(DateTime? toDatef) {
    toDate = toDatef;
    notifyListeners();
  }
}
