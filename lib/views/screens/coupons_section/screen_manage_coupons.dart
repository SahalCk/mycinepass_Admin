import 'package:cinepass_admin/controllers/manage_coupons_controller.dart';
import 'package:cinepass_admin/utils/colors.dart';
import 'package:cinepass_admin/utils/sized_boxes.dart';
import 'package:cinepass_admin/views/screens/coupons_section/screen_add_edit_coupon.dart';
import 'package:cinepass_admin/views/screens/coupons_section/screen_view_coupon.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_appbar.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_coupon_card.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_floating_action_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ManageCouponsScreen extends StatelessWidget {
  const ManageCouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appBar = CinePassAppBar();
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: backgroundColor),
        child: Scaffold(
          appBar:
              appBar.cinePassAppBar(context: context, title: 'Manage Coupons'),
          body: Padding(
              padding: EdgeInsets.symmetric(horizontal: Adaptive.w(4)),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Coupons')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done ||
                      snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      Provider.of<ManageCouponsController>(context,
                              listen: false)
                          .addValuesToList(snapshot);
                      return Consumer<ManageCouponsController>(
                          builder: (context, value, child) {
                        return value.allCoupons.isNotEmpty
                            ? ListView.separated(
                                padding: EdgeInsets.only(top: Adaptive.h(2.5)),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewCouponScreen(
                                                      couponModel: value
                                                          .allCoupons[index],
                                                      index: index)));
                                    },
                                    child: CinePassCouponCard(
                                        couponModel: value.allCoupons[index]),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return sizedBoxHeight10;
                                },
                                itemCount: value.allCoupons.length)
                            : const Center(
                                child: Text(
                                  'Coupons are not added!',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              );
                      });
                    } else {
                      return const ScaffoldMessenger(
                          child: Text('Something went wrong'));
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                          backgroundColor:
                              const Color.fromARGB(255, 207, 234, 255),
                          color: primaryColor,
                          strokeWidth: 6),
                    );
                  }
                },
              )),
          floatingActionButton: CinePassFloatingActionButton(
              function: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AddAndEditCouponScreen()));
              },
              text: 'Add New Coupon'),
        ));
  }
}
