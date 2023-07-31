import 'package:cinepass_admin/models/coupon_model.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CinePassCouponCard extends StatelessWidget {
  final CouponModel couponModel;
  const CinePassCouponCard({super.key, required this.couponModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Adaptive.w(3.5)),
      width: Adaptive.w(100),
      height: Adaptive.h(9.95),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(84, 168, 229, 0.1),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(couponModel.couponCode,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold)),
          SizedBox(
              width: Adaptive.w(95),
              child: Text(
                couponModel.couponDescription,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Color.fromARGB(255, 148, 148, 148), fontSize: 16),
              ))
        ],
      ),
    );
  }
}
