// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cinepass_admin/models/coupon_model.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_snack_bars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageCouponsController extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  List<CouponModel> allCoupons = [];
  List<QueryDocumentSnapshot<Object?>>? snapShotList;
  String choosedOption = 'Fixed Amount';
  DateTime? expiredDate;

  void changeChoosedOption(String value) {
    choosedOption = value;
    notifyListeners();
  }

  void expireDateSelected(DateTime dateTime) {
    expiredDate = dateTime;
    notifyListeners();
  }

  void presetChoosedOption(String choosedOptionR, DateTime? expdate) {
    choosedOption = choosedOptionR;
    expiredDate = expdate;
  }

  void addValuesToList(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    List<QueryDocumentSnapshot<Object?>>? list = snapshot.data?.docs.toList();
    snapShotList = list;
    allCoupons.clear();
    for (dynamic item in list!) {
      final model = CouponModel(
          item['couponCode'],
          item['couponDescription'],
          convertTimeStamp(item['couponExpireDate']),
          item['selectedOption'],
          item['discountFixedAmount'],
          item['discountPercentage'],
          item['discountAmountUpto'],
          item['minimumAmountToApply']);
      allCoupons.add(model);
    }
  }

  Future<void> addNewCoupon(
      BuildContext context, CouponModel couponModel) async {
    log(couponModel.discountPercentage.toString());
    try {
      await _firebaseFirestore.collection('Coupons').add({
        'couponCode': couponModel.couponCode,
        'couponDescription': couponModel.couponDescription,
        'couponExpireDate': couponModel.expDate,
        'selectedOption': couponModel.selectedOption,
        'discountPercentage': couponModel.discountPercentage,
        'discountAmountUpto': couponModel.uptoAmount,
        'discountFixedAmount': couponModel.discountAmount,
        'minimumAmountToApply': couponModel.minAmount
      });
      Navigator.of(context).pop();
      successSnackBar(context, 'Coupon Added Successfully');
    } catch (e) {
      Navigator.of(context).pop();
      errorSnackBar(context, e.toString());
    }
  }

  Future<void> updateCoupon(
      BuildContext context, int index, CouponModel couponModel) async {
    try {
      final id = snapShotList![index].id;
      await FirebaseFirestore.instance.collection('Coupons').doc(id).update({
        'couponCode': couponModel.couponCode,
        'couponDescription': couponModel.couponDescription,
        'couponExpireDate': couponModel.expDate,
        'selectedOption': couponModel.selectedOption,
        'discountPercentage': couponModel.discountPercentage,
        'discountAmountUpto': couponModel.uptoAmount,
        'discountFixedAmount': couponModel.discountAmount,
        'minimumAmountToApply': couponModel.minAmount
      });
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      successSnackBar(context, 'Coupon Updated Successfully');
    } catch (e) {
      Navigator.of(context).pop();
      errorSnackBar(context, e.toString());
    }
  }

  Future<void> deleteCoupon(BuildContext context, int index) async {
    try {
      final id = snapShotList![index].id;
      await FirebaseFirestore.instance.collection('Coupons').doc(id).delete();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      successSnackBar(context, 'Coupon Deleted Successfully');
    } catch (e) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      errorSnackBar(context, e.toString());
    }
  }

  DateTime convertTimeStamp(dynamic timeStamp) {
    Timestamp tempTimestamp = timeStamp;
    DateTime dateTime = tempTimestamp.toDate();
    return dateTime;
  }
}
