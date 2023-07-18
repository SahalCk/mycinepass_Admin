import 'package:cinepass_admin/controllers/login_screen_controller.dart';
import 'package:cinepass_admin/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CinePassTextFormField extends StatelessWidget {
  final String hint;
  final Icon? prefixIcon;
  final String fieldName;
  final bool? isDigitsOnly;
  final int? limit;
  final bool? isLast;
  final TextEditingController controller;

  const CinePassTextFormField(
      {super.key,
      required this.hint,
      this.prefixIcon,
      required this.fieldName,
      this.isDigitsOnly,
      this.limit,
      this.isLast,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 1,
      validator: (value) {
        if (value!.isEmpty) {
          return '$fieldName Field is Empty';
        }
        return null;
      },
      inputFormatters: [LengthLimitingTextInputFormatter(limit)],
      keyboardType:
          isDigitsOnly == true ? TextInputType.number : TextInputType.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: Adaptive.h(2)),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: Adaptive.w(2), right: Adaptive.w(1)),
            child: prefixIcon,
          ),
          prefixIconColor: primaryColor,
          hintText: hint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(color: textFormFieldColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(color: textFormFieldColor)),
          filled: true,
          fillColor: textFormFieldColor,
          hintStyle: TextStyle(color: hintColor)),
      style: const TextStyle(color: Colors.white),
      textInputAction: isLast == true ? null : TextInputAction.next,
    );
  }
}

class CinePassPasswordTextFormField extends StatelessWidget {
  final String hint;
  final Icon? prefixIcon;
  final TextEditingController passwordController;

  const CinePassPasswordTextFormField(
      {super.key,
      required this.hint,
      this.prefixIcon,
      required this.passwordController});

  @override
  Widget build(BuildContext context) {
    final passwordObscureController =
        Provider.of<LoginScreenProvider>(context, listen: false);

    return Consumer<LoginScreenProvider>(
      builder: (context, value, child) {
        return TextFormField(
          controller: passwordController,
          maxLines: 1,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Password Field is Empty';
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: value.obscureValue,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: Adaptive.h(2)),
              prefixIcon: Padding(
                padding:
                    EdgeInsets.only(left: Adaptive.w(2), right: Adaptive.w(1)),
                child: prefixIcon,
              ),
              prefixIconColor: primaryColor,
              hintText: hint,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide(color: textFormFieldColor)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide(color: textFormFieldColor)),
              filled: true,
              fillColor: textFormFieldColor,
              hintStyle: TextStyle(color: hintColor),
              suffixIcon: Padding(
                padding: EdgeInsets.only(right: Adaptive.w(1.5)),
                child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      passwordObscureController.changeObscure();
                    },
                    child: value.obscureValue
                        ? Icon(
                            Icons.visibility,
                            color: hintColor,
                            size: 23,
                          )
                        : Icon(
                            Icons.visibility_off,
                            color: hintColor,
                            size: 23,
                          )),
              )),
          style: const TextStyle(color: Colors.white),
        );
      },
    );
  }
}
