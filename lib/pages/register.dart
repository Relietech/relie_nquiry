import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:relie_nquiry/constants/app_colors.dart';
import 'package:relie_nquiry/constants/funtions/auth_services.dart';
import 'package:relie_nquiry/constants/text_fields.dart';

import '../constants/app_button.dart';
import '../constants/app_text_styles.dart';
import '../constants/funtions/asset_image.dart';
import '../routes/app_routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();



  bool _isLoading = false;
  bool _obscureConfirm1 = true; bool _obscureConfirm2 = true;
  void registerUser() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      //  showMessage("All fields are required.");
      return;
    }

    if (password != confirmPassword) {
      // showMessage("Passwords do not match.");
      return;
    }

    setState(() => _isLoading = true);

    final authService = AuthService();
    final result = await authService.registerUser(
      name: name,
      email: email,
      password: password,
    );

    setState(() => _isLoading = false);

    if (result == null) {
      Get.snackbar(
        "Register",
        "Registration successful!",
        backgroundColor: Colors.blue.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );

      Get.toNamed(Routes.logInPage);
    } else {
      Get.snackbar(
        "Register",
        "Registration Failed",
        backgroundColor: Colors.blue.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,

        body: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [SizedBox(height: 30),
              Image.asset(AppAssetImages.appLogo, height: 100),
              SizedBox(height: 20),
              Text(
                "Register your account",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),

              AppTextFields.textFormFieldHeading(
                context: context,
                controller: nameController,
                headingText: "Full Name",
                hintText: "Enter Name",
              ),

              SizedBox(height: 15),
              AppTextFields.textFormFieldHeading(
                context: context,
                controller: emailController,
                headingText: "Email Id",
                hintText: "Enter Email",
                keyboardType: TextInputType.emailAddress,
              ),


              SizedBox(height: 15),
              AppTextFields.textFormFieldHeading(
                context: context,
                controller: passwordController,
                headingText: "Password",
                hintText: "Enter Password",
                obscureText: _obscureConfirm1,maxLines: 1,
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      _obscureConfirm1 = !_obscureConfirm1;
                    });
                  },
                  child: Icon(
                    _obscureConfirm1 ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                ),
              ),


              SizedBox(height: 15),


        AppTextFields.textFormFieldHeading(
        context: context,
          controller: confirmPasswordController,
          headingText: "Confirm Password",
          hintText: "Enter Confirm Password",
          obscureText: _obscureConfirm2,maxLines: 1,
          suffixIcon: InkWell(
            onTap: () {
              setState(() {
                _obscureConfirm2 = !_obscureConfirm2;
              });
            },
            child: Icon(
              _obscureConfirm2 ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
          ),
        ),

        SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,

                child: SizedBox(
                  width: double.infinity,
                  child: AppButton.AppCustomButton(
                    paddingVertical: 12,
                    onTap: registerUser,
                    text: 'Register',
                    style: AppTextStyles.white16bold,
                    color: AppColors.appColor,
                  ),
                ),
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.logInPage);
                    },
                    child: Text(
                      "Login here",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.appColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),

        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          enabled: !_isLoading,
          decoration: InputDecoration(
            // labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: AppColors.appColor, width: 2),
            ),
            suffixIcon:
                obscure
                    ? Icon(Icons.lock_outline)
                    : (keyboardType == TextInputType.emailAddress
                        ? Icon(Icons.email_outlined)
                        : null),
          ),
        ),
      ],
    );
  }
}
