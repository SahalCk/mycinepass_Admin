import 'package:cinepass_admin/controllers/login_screen_controller.dart';
import 'package:cinepass_admin/utils/sized_boxes.dart';
import 'package:cinepass_admin/utils/text_styles.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_button.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_loading.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_logo.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AdminLoginScreen extends StatelessWidget {
  AdminLoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final emialController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginProvider =
        Provider.of<LoginScreenController>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Adaptive.w(7)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                sizedBoxHeight110,
                Align(
                    alignment: Alignment.center,
                    child: Text('Welcome Back !', style: loginPageTextStyle)),
                sizedBoxHeight80,
                const CinePassLogo(),
                sizedBoxHeight50,
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CinePassTextFormField(
                          hint: 'Enter Email',
                          prefixIcon: const Icon(Icons.mail_rounded, size: 25),
                          fieldName: 'Email',
                          controller: emialController),
                      sizedBoxHeight20,
                      CinePassPasswordTextFormField(
                          hint: 'Enter Password',
                          prefixIcon: const Icon(
                            Icons.lock,
                            size: 25,
                          ),
                          passwordController: passwordController),
                    ],
                  ),
                ),
                sizedBoxHeight80,
                CinePassButton(
                    function: () async {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return const CinePassLoading();
                          },
                        );
                        await loginProvider.signinButtonClicked(context,
                            emialController.text, passwordController.text);
                      }
                    },
                    text: 'Sign In'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
