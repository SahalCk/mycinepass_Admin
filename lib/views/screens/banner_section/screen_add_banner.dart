// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cinepass_admin/controllers/manage_banner_controller.dart';
import 'package:cinepass_admin/utils/colors.dart';
import 'package:cinepass_admin/utils/sized_boxes.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_appbar.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_button.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_loading.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_snack_bars.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddNewBannerScreen extends StatelessWidget {
  AddNewBannerScreen({super.key});

  final movieNameController = TextEditingController();
  final movieDescriptionController = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final appBar = CinePassAppBar();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          SystemUiOverlayStyle.light.copyWith(statusBarColor: backgroundColor),
      child: Scaffold(
        appBar:
            appBar.cinePassAppBar(context: context, title: 'Add New Banner'),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: Adaptive.w(4)),
          child: Form(
            key: _key,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  sizedBoxHeight40,
                  InkWell(
                    onTap: () async {
                      await Provider.of<ManageBannerController>(context,
                              listen: false)
                          .uploadBannerImage(context);
                    },
                    child: Consumer<ManageBannerController>(
                      builder: (context, value, child) {
                        return Container(
                            height: Adaptive.h(30),
                            width: Adaptive.w(100),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 3,
                                    color: primaryColor,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(8)),
                            child: value.bannerImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.file(File(value.bannerImage!),
                                        fit: BoxFit.fill))
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          height: Adaptive.h(13),
                                          child:
                                              Image.asset('assets/upload.png')),
                                      const Text("Tap to Upload Banner Image*",
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ));
                      },
                    ),
                  ),
                  sizedBoxHeight20,
                  CinePassTextFormField(
                      hint: 'Enter Movie Name',
                      fieldName: 'Movie Name',
                      prefixIcon:
                          const Icon(Icons.movie_creation_rounded, size: 25),
                      controller: movieNameController),
                  sizedBoxHeight20,
                  CinePassTextFormField(
                      hint: 'Enter Movie Description',
                      fieldName: 'Movie Description',
                      prefixIcon: const Icon(Icons.info_rounded, size: 25),
                      controller: movieDescriptionController),
                  sizedBoxHeight120,
                  sizedBoxHeight120,
                  sizedBoxHeight60,
                  CinePassButton(
                      function: () async {
                        if (_key.currentState!.validate() &&
                            Provider.of<ManageBannerController>(context,
                                        listen: false)
                                    .bannerImage !=
                                null) {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return const CinePassLoading();
                            },
                          );
                          final response =
                              await Provider.of<ManageBannerController>(context,
                                      listen: false)
                                  .addBanner(context, movieNameController.text,
                                      movieDescriptionController.text);
                          Navigator.of(context).pop();
                          if (response == true) {
                            successSnackBar(
                                context, 'Movie Banner Added Successfully');
                            Provider.of<ManageBannerController>(context,
                                    listen: false)
                                .makeNullandNotify();
                            movieNameController.clear();
                            movieDescriptionController.clear();
                          } else {
                            errorSnackBar(context, 'Something Went Wrong!');
                          }
                        }
                      },
                      text: 'Add Banner')
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
