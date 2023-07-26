// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cinepass_admin/controllers/manage_coupons_controller.dart';
import 'package:cinepass_admin/models/coupon_model.dart';
import 'package:cinepass_admin/utils/colors.dart';
import 'package:cinepass_admin/utils/sized_boxes.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_appbar.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_button.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_loading.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddAndEditCouponScreen extends StatelessWidget {
  final bool? isEditting;
  final int? index;
  const AddAndEditCouponScreen({super.key, this.isEditting, this.index});

  @override
  Widget build(BuildContext context) {
    final manageCouponsController =
        Provider.of<ManageCouponsController>(context, listen: false);

    if (isEditting == true) {
      manageCouponsController.presetChoosedOption(
          manageCouponsController.allCoupons[index!].selectedOption,
          manageCouponsController.allCoupons[index!].expDate);
    } else {
      manageCouponsController.presetChoosedOption('Fixed Amount', null);
    }

    final couponCodeController = TextEditingController(
        text: isEditting == true
            ? manageCouponsController.allCoupons[index!].couponCode
            : '');
    final couponDescriptionController = TextEditingController(
        text: isEditting == true
            ? manageCouponsController.allCoupons[index!].couponDescription
            : '');
    final couponExpDateController = TextEditingController(
        text: isEditting == true
            ? manageCouponsController.allCoupons[index!].expDate
                .toString()
                .substring(0, 10)
            : '');
    final couponMinAmountController = TextEditingController(
        text: isEditting == true
            ? manageCouponsController.allCoupons[index!].minAmount
            : '');
    final couponOffPercentage = TextEditingController(
        text: isEditting == true
            ? manageCouponsController.allCoupons[index!].discountPercentage ??
                ''
            : '');
    final couponOffAmount = TextEditingController(
        text: isEditting == true
            ? manageCouponsController.allCoupons[index!].discountAmount ?? ''
            : '');
    final couponOffUptoAmount = TextEditingController(
        text: isEditting == true
            ? manageCouponsController.allCoupons[index!].uptoAmount ?? ''
            : '');
    final _key = GlobalKey<FormState>();

    final appBar = CinePassAppBar();
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: backgroundColor),
        child: Scaffold(
          appBar: appBar.cinePassAppBar(
              context: context,
              title: isEditting == true ? 'Edit Coupon' : 'Add New Coupon'),
          body: Padding(
              padding: EdgeInsets.symmetric(horizontal: Adaptive.w(4)),
              child: SingleChildScrollView(
                child: Form(
                  key: _key,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sizedBoxHeight20,
                        CinePassTextFormField(
                            hint: 'Enter Coupon Code',
                            fieldName: 'Coupon Code',
                            controller: couponCodeController,
                            prefixIcon: const Icon(Icons.card_giftcard_rounded,
                                size: 25)),
                        sizedBoxHeight20,
                        CinePassTextFormField(
                            hint: 'Enter Coupon Description',
                            fieldName: 'Coupon Description',
                            controller: couponDescriptionController,
                            prefixIcon:
                                const Icon(Icons.info_rounded, size: 25)),
                        sizedBoxHeight20,
                        Consumer<ManageCouponsController>(
                          builder: (context, value, child) {
                            return CinePassTextFormField(
                              hint: 'Select Coupon Expire Date',
                              fieldName: 'Coupon Code',
                              controller: couponExpDateController,
                              function: () async {
                                final DateTime? selectedDate =
                                    await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2023),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 365)),
                                );
                                if (selectedDate == null) {
                                  return;
                                }
                                manageCouponsController
                                    .expireDateSelected(selectedDate);
                                couponExpDateController.text =
                                    manageCouponsController.expiredDate
                                        .toString()
                                        .substring(0, 10);
                              },
                              prefixIcon: const Icon(
                                  Icons.calendar_month_rounded,
                                  size: 25),
                            );
                          },
                        ),
                        sizedBoxHeight30,
                        const Text('Select An Option',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.5)),
                        Consumer<ManageCouponsController>(
                          builder: (context, value, child) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Radio(
                                        value: 'Fixed Amount',
                                        groupValue: value.choosedOption,
                                        onChanged: (value) {
                                          manageCouponsController
                                              .changeChoosedOption(value!);
                                        }),
                                    const Text('Fixed Amount (₹)',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.5)),
                                    Radio(
                                        value: 'Percentage',
                                        groupValue: value.choosedOption,
                                        onChanged: (value) {
                                          manageCouponsController
                                              .changeChoosedOption(value!);
                                        }),
                                    const Text('Percentage (%)',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.5)),
                                  ],
                                ),
                                sizedBoxHeight20,
                                value.choosedOption == 'Percentage'
                                    ? Column(
                                        children: [
                                          CinePassTextFormField(
                                              hint:
                                                  'Enter Discount Percentage (%)',
                                              fieldName: 'Offer Percentage',
                                              controller: couponOffPercentage,
                                              isDigitsOnly: true,
                                              prefixIcon: const Icon(
                                                  Icons.percent_rounded,
                                                  size: 25)),
                                          sizedBoxHeight20,
                                          CinePassTextFormField(
                                              hint: 'Enter Upto Amount (₹)',
                                              fieldName: 'Offer Percentage',
                                              isDigitsOnly: true,
                                              controller: couponOffUptoAmount,
                                              prefixIcon: const Icon(
                                                  Icons.currency_rupee_rounded,
                                                  size: 25)),
                                        ],
                                      )
                                    : CinePassTextFormField(
                                        hint: 'Enter Discount Amount (₹)',
                                        fieldName: 'Discount Amount',
                                        isDigitsOnly: true,
                                        controller: couponOffAmount,
                                        prefixIcon: const Icon(
                                            Icons.currency_rupee_rounded,
                                            size: 25)),
                                sizedBoxHeight20,
                                CinePassTextFormField(
                                    hint:
                                        'Enter Minimum Amount to Apply Offer (₹)',
                                    fieldName: 'Minimum Amount',
                                    controller: couponMinAmountController,
                                    isDigitsOnly: true,
                                    prefixIcon: const Icon(
                                        Icons.currency_rupee_rounded,
                                        size: 25)),
                              ],
                            );
                          },
                        ),
                        sizedBoxHeight120,
                        Consumer<ManageCouponsController>(
                          builder: (context, value, child) {
                            return manageCouponsController.choosedOption ==
                                    'Fixed Amount'
                                ? sizedBoxHeight148
                                : sizedBoxHeight60;
                          },
                        ),
                        CinePassButton(
                            function: () async {
                              if (isEditting == true) {
                                if (_key.currentState!.validate()) {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return const CinePassLoading();
                                    },
                                  );
                                  await manageCouponsController.updateCoupon(
                                      context,
                                      index!,
                                      CouponModel(
                                          couponCodeController.text,
                                          couponDescriptionController.text,
                                          manageCouponsController.expiredDate!,
                                          manageCouponsController.choosedOption,
                                          couponOffAmount.text,
                                          couponOffPercentage.text,
                                          couponOffUptoAmount.text,
                                          couponMinAmountController.text));
                                }
                              } else {
                                if (_key.currentState!.validate()) {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return const CinePassLoading();
                                    },
                                  );
                                  await manageCouponsController.addNewCoupon(
                                      context,
                                      CouponModel(
                                          couponCodeController.text,
                                          couponDescriptionController.text,
                                          manageCouponsController.expiredDate!,
                                          manageCouponsController.choosedOption,
                                          couponOffAmount.text,
                                          couponOffPercentage.text,
                                          couponOffUptoAmount.text,
                                          couponMinAmountController.text));
                                  couponCodeController.clear();
                                  couponDescriptionController.clear();
                                  couponExpDateController.clear();
                                  manageCouponsController
                                      .changeChoosedOption('Fixed Amount');
                                  couponOffAmount.clear();
                                  couponOffPercentage.clear();
                                  couponOffUptoAmount.clear();
                                  couponMinAmountController.clear();
                                }
                              }
                            },
                            text: isEditting == true
                                ? 'Update Coupon'
                                : 'Add Coupon')
                      ]),
                ),
              )),
        ));
  }
}
