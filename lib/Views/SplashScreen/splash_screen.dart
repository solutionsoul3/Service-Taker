import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:talk/Views/auth/login_screen.dart';
import 'package:talk/constants/colors.dart';
import 'package:talk/constants/image.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Connecting You to the Best Services',
              style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.white,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'Talk Time',
              style: TextStyle(
                  fontSize: 18.sp,
                  color: AppColors.logocolor,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold),
            ),
            Image.asset(
              AppImages.splashlogo,
              width: 250.w,
              height: 250.h,
            ),
            Text(
              'Quick. Easy. Reliable',
              style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.white,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const SpinKitFadingCircle(
              color: AppColors.logocolor,
            )
          ],
        ),
      ),
    );
  }
}
