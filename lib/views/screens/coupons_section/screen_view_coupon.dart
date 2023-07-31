import 'package:cinepass_admin/controllers/manage_coupons_controller.dart';
import 'package:cinepass_admin/models/coupon_model.dart';
import 'package:cinepass_admin/utils/colors.dart';
import 'package:cinepass_admin/utils/sized_boxes.dart';
import 'package:cinepass_admin/views/screens/coupons_section/screen_add_edit_coupon.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_appbar.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ViewCouponScreen extends StatelessWidget {
  final CouponModel couponModel;
  final int index;
  const ViewCouponScreen(
      {super.key, required this.couponModel, required this.index});

  @override
  Widget build(BuildContext context) {
    final appBar = CinePassAppBar();
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: backgroundColor),
        child: Scaffold(
            appBar: appBar.cinePassAppBar(
                context: context, title: couponModel.couponCode),
            body: Padding(
                padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sizedBoxHeight30,
                      const Text('Coupon Code',
                          style: TextStyle(
                              color: Color.fromARGB(255, 148, 148, 148),
                              fontSize: 16)),
                      Text(couponModel.couponCode,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      sizedBoxHeight30,
                      const Text('Coupon Description',
                          style: TextStyle(
                              color: Color.fromARGB(255, 148, 148, 148),
                              fontSize: 16)),
                      Text(couponModel.couponDescription,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      sizedBoxHeight30,
                      const Text('Coupon Expiry Date',
                          style: TextStyle(
                              color: Color.fromARGB(255, 148, 148, 148),
                              fontSize: 16)),
                      Text(couponModel.expDate.toString().substring(0, 10),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      sizedBoxHeight30,
                      const Text('Coupon Type',
                          style: TextStyle(
                              color: Color.fromARGB(255, 148, 148, 148),
                              fontSize: 16)),
                      Text(couponModel.selectedOption,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      sizedBoxHeight30,
                      couponModel.selectedOption == 'Fixed Amount'
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Discount Amount',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 148, 148, 148),
                                        fontSize: 16)),
                                Text(
                                    '₹${couponModel.discountAmount.toString()}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                sizedBoxHeight30
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Discount Percentage',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 148, 148, 148),
                                        fontSize: 16)),
                                Text(
                                    '${couponModel.discountPercentage.toString()}%',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                sizedBoxHeight30,
                                const Text('Discount Upto Amount',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 148, 148, 148),
                                        fontSize: 16)),
                                Text('₹${couponModel.uptoAmount.toString()}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                sizedBoxHeight30,
                              ],
                            ),
                      const Text('Minimum Amount to Apply Coupon',
                          style: TextStyle(
                              color: Color.fromARGB(255, 148, 148, 148),
                              fontSize: 16)),
                      Text('₹${couponModel.minAmount.toString()}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      couponModel.selectedOption == 'Fixed Amount'
                          ? sizedBoxHeight160
                          : sizedBoxHeight70,
                      SizedBox(
                        width: Adaptive.w(100),
                        height: Adaptive.h(6.7),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13))),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AddAndEditCouponScreen(
                                      isEditting: true, index: index)));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.edit, color: Colors.white),
                                SizedBox(
                                  width: Adaptive.w(1),
                                ),
                                const Text(
                                  'Edit Coupon',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                      ),
                      sizedBoxHeight20,
                      SizedBox(
                        width: Adaptive.w(100),
                        height: Adaptive.h(6.7),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13))),
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      title: Text(
                                        'Are you sure you want to delete ${couponModel.couponCode} Coupon?',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () async {
                                              showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) {
                                                  return const CinePassLoading();
                                                },
                                              );
                                              await Provider.of<
                                                          ManageCouponsController>(
                                                      context,
                                                      listen: false)
                                                  .deleteCoupon(context, index);
                                            },
                                            child: const Text('Yes')),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('No'))
                                      ],
                                    );
                                  });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.delete_rounded,
                                    color: Colors.white),
                                SizedBox(
                                  width: Adaptive.w(1),
                                ),
                                const Text(
                                  'Delete Coupon',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                      )
                    ],
                  ),
                ))));
  }
}
