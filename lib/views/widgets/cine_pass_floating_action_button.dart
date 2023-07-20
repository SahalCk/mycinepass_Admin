import 'package:cinepass_admin/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CinePassFloatingActionButton extends StatelessWidget {
  final Function() function;
  final String text;
  const CinePassFloatingActionButton(
      {super.key, required this.function, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Adaptive.w(93),
      height: Adaptive.h(6.7),
      child: FloatingActionButton.extended(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
          backgroundColor: primaryColor,
          onPressed: function,
          label: Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
          )),
    );
  }
}
