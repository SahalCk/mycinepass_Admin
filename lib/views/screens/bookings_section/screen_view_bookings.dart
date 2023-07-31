// ignore_for_file: use_build_context_synchronously

import 'package:cinepass_admin/controllers/view_bookings_controller.dart';
import 'package:cinepass_admin/utils/colors.dart';
import 'package:cinepass_admin/utils/sized_boxes.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_appbar.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_booking.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ViewBookingsScreen extends StatelessWidget {
  const ViewBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingsController =
        Provider.of<ViewBookingsController>(context, listen: false);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          SystemUiOverlayStyle.light.copyWith(statusBarColor: backgroundColor),
      child: Scaffold(
        appBar: CinePassAppBar().cinePassAppBar(
          context: context,
          title: 'View Bookings',
          trailingIcon:
              const Icon(Icons.download_rounded, color: Colors.white, size: 28),
          trailingFunction: () async {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return const CinePassLoading();
              },
            );
            await bookingsController.generateExcel(context);
          },
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: Adaptive.w(4)),
            child: Column(
              children: [
                sizedBoxHeight20,
                Consumer<ViewBookingsController>(
                  builder: (context, value, child) {
                    final fromDateController = TextEditingController(
                        text: value.fromDate != null
                            ? value.fromDate.toString().substring(0, 10)
                            : '');
                    final toDateController = TextEditingController(
                        text: value.toDate != null
                            ? value.toDate.toString().substring(0, 10)
                            : '');
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: Adaptive.h(6),
                          width: Adaptive.w(37),
                          child: TextField(
                            showCursor: false,
                            controller: fromDateController,
                            keyboardType: TextInputType.none,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: textFormFieldColor,
                                suffixIcon:
                                    const Icon(Icons.calendar_month_rounded),
                                suffixIconColor: primaryColor,
                                hintStyle: TextStyle(
                                    color: hintColor,
                                    fontWeight: FontWeight.bold),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        BorderSide(color: textFormFieldColor)),
                                hintText: 'From Date'),
                            onTap: () async {
                              DateTime currentDate = DateTime.now();
                              final fromDate = await showDatePicker(
                                  initialDate: DateTime.now(),
                                  firstDate: currentDate
                                      .subtract(const Duration(days: 365)),
                                  lastDate: currentDate
                                      .add(const Duration(days: 365)),
                                  initialDatePickerMode: DatePickerMode.day,
                                  context: context);

                              Provider.of<ViewBookingsController>(context,
                                      listen: false)
                                  .setFromDate(fromDate!);
                            },
                          ),
                        ),
                        SizedBox(
                          height: Adaptive.h(6),
                          width: Adaptive.w(37),
                          child: TextField(
                            showCursor: false,
                            controller: toDateController,
                            keyboardType: TextInputType.none,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: textFormFieldColor,
                                suffixIcon:
                                    const Icon(Icons.calendar_month_rounded),
                                suffixIconColor: primaryColor,
                                hintStyle: TextStyle(
                                    color: hintColor,
                                    fontWeight: FontWeight.bold),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        BorderSide(color: textFormFieldColor)),
                                hintText: 'To Date'),
                            onTap: () async {
                              DateTime currentDate = DateTime.now();
                              final toDate = await showDatePicker(
                                  initialDate: DateTime.now(),
                                  firstDate: currentDate
                                      .subtract(const Duration(days: 365)),
                                  lastDate: currentDate
                                      .add(const Duration(days: 365)),
                                  initialDatePickerMode: DatePickerMode.day,
                                  context: context);
                              Provider.of<ViewBookingsController>(context,
                                      listen: false)
                                  .setToDate(toDate!);
                            },
                          ),
                        ),
                        IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              Provider.of<ViewBookingsController>(context,
                                      listen: false)
                                  .setFromDate(null);
                              Provider.of<ViewBookingsController>(context,
                                      listen: false)
                                  .setToDate(null);
                            },
                            icon: const Icon(
                              Icons.close_rounded,
                              size: 26,
                              color: Colors.white,
                            ))
                      ],
                    );
                  },
                ),
                sizedBoxHeight10,
                Consumer<ViewBookingsController>(
                  builder: (context, value, child) {
                    if (value.fromDate == null || value.toDate == null) {
                      return FutureBuilder(
                        future: bookingsController.getAllBookings(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.active ||
                              snapshot.connectionState ==
                                  ConnectionState.done) {
                            if (snapshot.hasData) {
                              return Expanded(
                                child: ListView.separated(
                                    padding:
                                        EdgeInsets.only(top: Adaptive.h(1)),
                                    itemBuilder: (context, index) {
                                      return CinePassBookingCard(
                                          movieBookingModel:
                                              snapshot.data![index]);
                                    },
                                    separatorBuilder: (context, index) {
                                      return sizedBoxHeight10;
                                    },
                                    itemCount: snapshot.data!.length),
                              );
                            } else {
                              return const Expanded(
                                child: Center(
                                  child: Text(
                                    'No Bookings Found',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              );
                            }
                          } else {
                            return Expanded(
                                child: Center(
                              child: CircularProgressIndicator(
                                  backgroundColor:
                                      const Color.fromARGB(255, 207, 234, 255),
                                  color: primaryColor,
                                  strokeWidth: 6),
                            ));
                          }
                        },
                      );
                    } else {
                      bookingsController.setSortedList();
                      if (value.sortedList.isNotEmpty) {
                        return Expanded(
                            child: ListView.separated(
                                padding: EdgeInsets.only(top: Adaptive.h(1)),
                                itemBuilder: (context, index) {
                                  return CinePassBookingCard(
                                      movieBookingModel:
                                          value.sortedList[index]);
                                },
                                separatorBuilder: (context, index) {
                                  return sizedBoxHeight10;
                                },
                                itemCount: value.sortedList.length));
                      } else {
                        return const Expanded(
                          child: Center(
                            child: Text(
                              'No Bookings Found',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            )),
      ),
    );
  }
}
