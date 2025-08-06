// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import '../constants/app_constants.dart' show AppConstants;
// import '../routes/app_routes.dart';
// import '../screen/home_page.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isLoading = false;
//   Future<void> _login() async {
//     final email = _emailController.text.trim();
//     final password = _passwordController.text;
//
//     if (email.isEmpty || password.isEmpty) {
//       Get.snackbar(
//         'Error',
//         'Email and password must not be empty',
//         backgroundColor: Colors.red.shade400,
//         colorText: Colors.white,
//       );
//       return;
//     }
//
//     setState(() => _isLoading = true);
//
//     try {
//       // Step 1: Check Firestore 'users' collection for the given email
//       final QuerySnapshot userQuery = await FirebaseFirestore.instance
//           .collection('users')
//           .where('userName', isEqualTo: email) // assuming 'userName' holds the email
//           .limit(1)
//           .get();
//
//       if (userQuery.docs.isEmpty) {
//         Get.snackbar(
//           'Error',
//           'No user record found in Firestore for this email.',
//           backgroundColor: Colors.red.shade400,
//           colorText: Colors.white,
//         );
//         return;
//       }
//
//       // Step 2: Proceed to Firebase Auth login
//       final UserCredential userCredential = await FirebaseAuth.instance
//           .signInWithEmailAndPassword(email: email, password: password);
//
//       Get.snackbar(
//         'Success',
//         'Login successful',
//         backgroundColor: Colors.green.shade400,
//         colorText: Colors.white,
//       );
//
//    Get.toNamed(Routes.selectEnquiry);
//     } on FirebaseAuthException catch (e) {
//       String errorMessage = 'Login failed';
//       if (e.code == 'user-not-found') {
//         errorMessage = 'No user found with this email.';
//       } else if (e.code == 'wrong-password') {
//         errorMessage = 'Incorrect password.';
//       }
//       Get.snackbar(
//         'Error',
//         errorMessage,
//         backgroundColor: Colors.red.shade400,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Something went wrong. Try again.',
//         backgroundColor: Colors.red.shade400,
//         colorText: Colors.white,
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 24.0),
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           // gradient: LinearGradient(
//           //   colors: [
//           //     Color(0xFF229CB8),
//           //     Color(0xFF2098B3),
//           //     Color(0xFF13859F),
//           //     Color(0xFF066A81),
//           //   ],
//           //   begin: Alignment.topCenter,
//           //   end: Alignment.bottomCenter,
//           // ),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 100),
//               Image.asset(
//                 'asset/image/relietech logo.png',
//                 height: 100,
//               ),
//               const SizedBox(height: 30),
//               const Text(
//                 'Welcome Back!',
//                 style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Login to your account',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//               ),
//               const SizedBox(height: 40),
//               TextField(
//                 controller: _emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: InputDecoration(
//                   hintText: "Enter Email",
//                   labelText: "Email",
//                   border: OutlineInputBorder(),
//                   fillColor: Colors.white,
//                   filled: true,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _passwordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   hintText: "Enter Password",
//                   labelText: "Password",
//                   border: OutlineInputBorder(),
//                   fillColor: Colors.white,
//                   filled: true,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: TextButton(
//                   onPressed: () {
//
//                   },
//                   child: const Text('Forgot Password?', style: TextStyle(color: Colors.black)),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               _isLoading
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : ElevatedButton(
//                 onPressed: _login,
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
//                   backgroundColor: Colors.black,
//                 ),
//                 child: const Text("Login", style: TextStyle(color: Colors.white)),
//               ),
//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:relie_nquiry/constants/funtions/asset_image.dart';

import '../constants/app_button.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/funtions/auth_services.dart';
import '../routes/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Email and password must not be empty',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isLoading = true);

    final authService = AuthService();
    final String? result = await authService.loginUser(
      email: email,
      password: password,
    );

    setState(() => _isLoading = false);

    if (result == null) {
      Get.snackbar('Success', 'Login successful', colorText: Colors.white);
      Get.offAllNamed(Routes.homeScreen);
    } else {
      Get.snackbar(
        'Error',
        result,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    }
  }

  var obscure_Text = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 100),
                Image.asset(AppAssetImages.appLogo, height: 100),
                const SizedBox(height: 30),
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Login to your account',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  cursorColor: AppColors.appColor,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Enter Username",
                    labelText: "Username",
                    labelStyle: TextStyle(color: AppColors.black),
                    // Add this line
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: AppColors.appColor,
                        width: 2,
                      ),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  cursorColor: AppColors.appColor,
                  controller: _passwordController,
                  obscureText: obscure_Text,
                  decoration: InputDecoration(
                    hintText: "Enter Password",
                    labelText: "Password",
                    labelStyle: TextStyle(color: AppColors.black),
                    // Add this line
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: AppColors.appColor,
                        width: 2,
                      ),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          obscure_Text = !obscure_Text;
                        });
                      },
                      child: Icon(
                        obscure_Text ? Icons.visibility_off : Icons.visibility,
                        color: obscure_Text ? Colors.grey : AppColors.appColor,
                        size: 20,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 60),
                _isLoading
                    ? const CircularProgressIndicator(color: AppColors.appColor)
                    : SizedBox(
                      width: double.infinity,
                      child: AppButton.AppCustomButton(
                        paddingVertical: 12,
                        onTap: _login,
                        text: 'Login',
                        style: AppTextStyles.white16bold,
                        color: AppColors.appColor,
                      ),
                    ),
                const SizedBox(height: 80),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text(
                //       "Didn't have an account? ",
                //       style: TextStyle(fontSize: 16, color: Colors.black),
                //     ),
                //     InkWell(
                //       onTap: () {
                //         Get.toNamed(Routes.registerPage);
                //         // TODO: Add forgot password functionality
                //       },
                //       child: const Text(
                //         'sign Up',
                //         style: TextStyle(color: AppColors.appColor, fontSize: 16),
                //       ),
                //     ),
                //   ],
                // ),

                // const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
