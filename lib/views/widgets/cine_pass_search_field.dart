import 'package:cinepass_admin/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CinePassSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Function(String query)? function;
  final Function()? clearingFunction;

  const CinePassSearchField(
      {super.key,
      required this.controller,
      required this.hint,
      this.function,
      this.clearingFunction});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 1,
      onChanged: function,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: Adaptive.h(2)),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: Adaptive.w(2), right: Adaptive.w(1)),
            child: const Icon(Icons.search),
          ),
          prefixIconColor: Colors.white,
          hintText: hint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(color: textFormFieldColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(color: textFormFieldColor)),
          filled: true,
          suffixIcon: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: clearingFunction,
              child: const Icon(Icons.close_rounded, color: Colors.white)),
          fillColor: textFormFieldColor,
          hintStyle: TextStyle(color: hintColor)),
      style: const TextStyle(color: Colors.white),
    );
  }
}
