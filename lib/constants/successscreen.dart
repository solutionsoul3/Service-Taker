import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:talk/constants/colors.dart';

class CongratulationsScreen extends StatelessWidget {
  const CongratulationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 500),
      () {},
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.logocolor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 50.h),
              Icon(
                Icons.check_circle,
                color: AppColors.logocolor,
                size: 150.h,
              ),
              SizedBox(height: 20.h),
              Text(
                'Congratulations on Booking Your Service!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Urbanist',
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Thank you for choosing us! We are thrilled to serve you and are '
                'committed to delivering an exceptional experience. Your trust in our '
                'services means the world to us, and we look forward to exceeding your '
                'expectations. Let’s make this a great journey together!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: 'Urbanist',
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
              SizedBox(height: 50.h),
              const SpinKitFadingCircle(
                color: AppColors.logocolor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
