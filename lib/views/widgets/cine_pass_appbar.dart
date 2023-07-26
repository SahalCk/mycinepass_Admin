import 'package:cinepass_admin/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CinePassAppBar {
  PreferredSizeWidget cinePassAppBar(
      {required BuildContext context,
      required String title,
      Icon? trailingIcon,
      Function()? trailingFunction}) {
    return PreferredSize(
        preferredSize: Size.fromHeight(Adaptive.h(7)),
        child: SafeArea(
          child: Container(
            color: backgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                    )),
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                trailingIcon == null
                    ? SizedBox(
                        width: Adaptive.w(8),
                      )
                    : IconButton(
                        onPressed: trailingFunction, icon: trailingIcon),
              ],
            ),
          ),
        ));
  }
}
