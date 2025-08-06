import 'package:flutter/material.dart';
import 'package:relie_nquiry/constants/app_colors.dart';

class QuotationPage extends StatefulWidget {
  const QuotationPage({super.key});

  @override
  State<QuotationPage> createState() => _QuotationPageState();
}

class _QuotationPageState extends State<QuotationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              height: 150,
              //  width: 100,
              "asset/image/coming soon.jpg",
            ),
            Text(
              "Quotation",
              style: TextStyle(
                color: AppColors.appColor,
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
            Text(
              "Coming Soon...",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        elevation: 5,
        shape: const CircleBorder(),
        backgroundColor: AppColors.appColor,
        child: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
      ),
    );
  }
}
