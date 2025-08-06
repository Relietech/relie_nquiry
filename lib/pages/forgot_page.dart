import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_button.dart';
import '../constants/app_colors.dart';
import '../constants/text_fields.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key});

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Forgot Password",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.appColor,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              SizedBox(height: 40),
              AppTextFields.textFormFieldHeading(
                context: context,
                // obscureText: false,
                controller: _emailController,
                headingText:
                    "Enter your email to receive reset instructions number *",
                hintText: "Email",
                keyboardType: TextInputType.phone,
              ),

              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: AppButton.AppSubmitButton(
                    onPressed: () {
                      // AppConstants.changeScreen(context, EnterPhoneNum());
                    },
                    text: "Send Reset Link",
                    paddingVertical: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
