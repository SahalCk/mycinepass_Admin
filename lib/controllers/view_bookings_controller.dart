// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cinepass_admin/models/booking_model.dart';
import 'package:cinepass_admin/services/api_services.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_snack_bars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

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

  Future<void> generateExcel(BuildContext context) async {
    log(allBookingsList.length.toString());
    try {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').setText('Id');
      sheet.getRangeByName('A1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('B1').setText('User Name');
      sheet.getRangeByName('B1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('C1').setText('Movie Name');
      sheet.getRangeByName('C1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('D1').setText('Theater Name');
      sheet.getRangeByName('D1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('E1').setText('Location');
      sheet.getRangeByName('E1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('F1').setText('Show time');
      sheet.getRangeByName('F1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('G1').setText('Date and Time');
      sheet.getRangeByName('G1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('H1').setText('Seats');
      sheet.getRangeByName('H1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('I1').setText('Booking ID');
      sheet.getRangeByName('I1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('J1').setText('Sub Total');
      sheet.getRangeByName('J1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('K1').setText('Fee');
      sheet.getRangeByName('K1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('L1').setText('Total');
      sheet.getRangeByName('L1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('M1').setText('Screen');
      sheet.getRangeByName('M1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('N1').setText('Status');
      sheet.getRangeByName('N1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('O1').setText('Language');
      sheet.getRangeByName('O1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('P1').setText('Image Url');
      sheet.getRangeByName('P1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('Q1').setText('Payment Status');
      sheet.getRangeByName('Q1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('R1').setText('Created At');
      sheet.getRangeByName('R1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('S1').setText('Updated At');
      sheet.getRangeByName('S1').builtInStyle = BuiltInStyles.heading1;

      if (fromDate == null || toDate == null) {
        for (int i = 0; i < allBookingsList.length; i++) {
          sheet
              .getRangeByName('A${(i + 2).toString()}')
              .setText(allBookingsList[i].id);
          sheet
              .getRangeByName('B${(i + 2).toString()}')
              .setText(allBookingsList[i].userName);
          sheet
              .getRangeByName('C${(i + 2).toString()}')
              .setText(allBookingsList[i].movieName);
          sheet
              .getRangeByName('D${(i + 2).toString()}')
              .setText(allBookingsList[i].ownerName);
          sheet
              .getRangeByName('E${(i + 2).toString()}')
              .setText(allBookingsList[i].location);
          sheet
              .getRangeByName('F${(i + 2).toString()}')
              .setText(allBookingsList[i].showTime);
          sheet
              .getRangeByName('G${(i + 2).toString()}')
              .setDateTime(allBookingsList[i].date);
          sheet
              .getRangeByName('H${(i + 2).toString()}')
              .setText(getSeatNumbers(allBookingsList[i].selectedSeats));
          sheet
              .getRangeByName('I${(i + 2).toString()}')
              .setText(allBookingsList[i].bookingId);
          sheet
              .getRangeByName('J${(i + 2).toString()}')
              .setValue(allBookingsList[i].subtotal);
          sheet
              .getRangeByName('K${(i + 2).toString()}')
              .setValue(allBookingsList[i].fee);
          sheet
              .getRangeByName('L${(i + 2).toString()}')
              .setValue(allBookingsList[i].total);
          sheet
              .getRangeByName('M${(i + 2).toString()}')
              .setValue(allBookingsList[i].screen);
          sheet
              .getRangeByName('N${(i + 2).toString()}')
              .setText(allBookingsList[i].status);
          sheet
              .getRangeByName('O${(i + 2).toString()}')
              .setText(allBookingsList[i].language);
          sheet
              .getRangeByName('P${(i + 2).toString()}')
              .setText(allBookingsList[i].image);
          sheet
              .getRangeByName('Q${(i + 2).toString()}')
              .setText(allBookingsList[i].paymentStatus);
          sheet
              .getRangeByName('R${(i + 2).toString()}')
              .setDateTime(allBookingsList[i].createdAt);
          sheet
              .getRangeByName('S${(i + 2).toString()}')
              .setDateTime(allBookingsList[i].updatedAt);
        }
      } else {
        for (int i = 0; i < sortedList.length; i++) {
          sheet
              .getRangeByName('A${(i + 2).toString()}')
              .setText(sortedList[i].id);
          sheet
              .getRangeByName('B${(i + 2).toString()}')
              .setText(sortedList[i].userName);
          sheet
              .getRangeByName('C${(i + 2).toString()}')
              .setText(sortedList[i].movieName);
          sheet
              .getRangeByName('D${(i + 2).toString()}')
              .setText(sortedList[i].ownerName);
          sheet
              .getRangeByName('E${(i + 2).toString()}')
              .setText(sortedList[i].location);
          sheet
              .getRangeByName('F${(i + 2).toString()}')
              .setText(sortedList[i].showTime);
          sheet
              .getRangeByName('G${(i + 2).toString()}')
              .setDateTime(sortedList[i].date);
          sheet
              .getRangeByName('H${(i + 2).toString()}')
              .setText(getSeatNumbers(sortedList[i].selectedSeats));
          sheet
              .getRangeByName('I${(i + 2).toString()}')
              .setText(sortedList[i].bookingId);
          sheet
              .getRangeByName('J${(i + 2).toString()}')
              .setValue(sortedList[i].subtotal);
          sheet
              .getRangeByName('K${(i + 2).toString()}')
              .setValue(sortedList[i].fee);
          sheet
              .getRangeByName('L${(i + 2).toString()}')
              .setValue(sortedList[i].total);
          sheet
              .getRangeByName('M${(i + 2).toString()}')
              .setValue(sortedList[i].screen);
          sheet
              .getRangeByName('N${(i + 2).toString()}')
              .setText(sortedList[i].status);
          sheet
              .getRangeByName('O${(i + 2).toString()}')
              .setText(sortedList[i].language);
          sheet
              .getRangeByName('P${(i + 2).toString()}')
              .setText(sortedList[i].image);
          sheet
              .getRangeByName('Q${(i + 2).toString()}')
              .setText(sortedList[i].paymentStatus);
          sheet
              .getRangeByName('R${(i + 2).toString()}')
              .setDateTime(sortedList[i].createdAt);
          sheet
              .getRangeByName('S${(i + 2).toString()}')
              .setDateTime(sortedList[i].updatedAt);
        }
      }

      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();
      final String path = (await getApplicationSupportDirectory()).path;
      final String fileName = '$path/mycinepassreport.xlsx';
      log(fileName.toString());
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      Navigator.of(context).pop();
      OpenFile.open(fileName);
    } catch (e) {
      Navigator.of(context).pop();
      errorSnackBar(context, e.toString());
    }
  }

  String getSeatNumbers(List<Seat> seatsList) {
    String seats = '';
    for (Seat seat in seatsList) {
      seats = '$seats,${seat.id}';
    }
    return seats.substring(1);
  }
}
