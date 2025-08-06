import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:relie_nquiry/add_enquiry/new_form_page.dart';
import 'package:relie_nquiry/constants/app_colors.dart';
import 'package:relie_nquiry/followup/followup_screen.dart';
import 'package:relie_nquiry/screen/home_page.dart';

class BottomBarPage extends StatefulWidget {
  const BottomBarPage({super.key});

  @override
  State<BottomBarPage> createState() => _BottomBarPageState();
}

class _BottomBarPageState extends State<BottomBarPage> {
  late int _tabIndex;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    _tabIndex = 1;
    pageController = PageController(initialPage: _tabIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _tabIndex = index;
    });
    pageController.jumpToPage(index);
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.white,
              title: const Text('Confirm Exit'),
              content: const Text(
                'Are you sure you want to exit?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              actions: <Widget>[
                TextButton(
                  style: ButtonStyle(),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppColors.themeRed,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    overlayColor: WidgetStatePropertyAll(
                      AppColors.appColor.withOpacity(0.3),
                    ),
                  ),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: const Text(
                    'Exit',
                    style: TextStyle(
                      color: AppColors.themeBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _showExitConfirmationDialog(context);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                _tabIndex = index;
              });
            },
            children: [NewFormPage(), HomePage(), FollowupScreen()],
          ),
          bottomNavigationBar: CircleNavBar(
            circleColor: AppColors.themeBlue,
            activeIcons: const [
              Icon(Icons.add, color: Colors.white),
              Icon(Icons.home, color: Colors.white),
              Icon(Icons.follow_the_signs, color: Colors.white),
            ],
            inactiveIcons: const [
              Text(
                "Add",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                "Home",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                "Follow Up",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
            color: AppColors.themeBlue,
            height: 60,
            circleWidth: 60,
            activeIndex: _tabIndex,
            onTap: _onTabTapped,
            padding:  EdgeInsets.only(left: 10, right: 10, bottom: 15),
            cornerRadius:  BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(24),
              bottomLeft: Radius.circular(24),
            ),
            elevation: 10,
            // gradient: LinearGradient(
            //   colors: [
            //     Color(0xFF229CB8),
            //     Color(0xFF2098B3),
            //     Color(0xFF13859f),
            //     Color(0xFF066a81),
            //   ],
            //   begin: Alignment.centerRight,
            //   end: Alignment.centerLeft,
            // ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:circle_nav_bar/circle_nav_bar.dart';
// import 'package:get/get.dart';
//
// import '../constants/app_colors.dart';
// import '../routes/app_routes.dart';
//
// class Bottombar extends StatefulWidget {
//   @override
//   State<Bottombar> createState() => _BottombarState();
// }
//
// class _BottombarState extends State<Bottombar> {
//   int _tabIndex = 1;
//
//   void _onTabTapped(int index) {
//     setState(() {
//       _tabIndex = index;
//     });
//
//     switch (index) {
//       case 0:
//         Get.offAllNamed(Routes.addEnquiryForm);
//         break;
//       case 1:
//         Get.offAllNamed(Routes.homeScreen);
//         break;
//       case 2:
//         Get.offAllNamed(Routes.followUpScreen);
//         break;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return CircleNavBar(
//       circleColor: AppColors.appColor,
//       activeIcons: const [
//         Icon(Icons.add, color: Colors.white),
//         Icon(Icons.home, color: Colors.white),
//         Icon(Icons.follow_the_signs, color: Colors.white),
//       ],
//       inactiveIcons: const [
//         Text("Add", style: TextStyle(fontSize: 16, color: Colors.white)),
//         Text("Home", style: TextStyle(fontSize: 16, color: Colors.white)),
//         Text("Follow Up", style: TextStyle(fontSize: 16, color: Colors.white)),
//       ],
//       color: AppColors.appColor,
//       height: 60,
//       circleWidth: 60,
//       activeIndex: _tabIndex,
//       onTap: _onTabTapped,
//       padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
//       cornerRadius: const BorderRadius.only(
//         topLeft: Radius.circular(8),
//         topRight: Radius.circular(8),
//         bottomRight: Radius.circular(24),
//         bottomLeft: Radius.circular(24),
//       ),
//       elevation: 10,
//     );
//   }
// }
