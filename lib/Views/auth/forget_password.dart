import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/Views/auth/signup_screen.dart';
import 'package:talk/constants/image.dart';

import '../../Constants/colors.dart';
import '../../constants/reusable_button.dart';
import '../../widgets/textfields.dart';
import 'login_screen.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  // 🔥 Function to send reset email
  Future<void> _sendPasswordResetEmail() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address')),
      );
      return;
    }

    try {
      setState(() => isLoading = true);

      // ✅ Send password reset email through Firebase
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset link sent to $email'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear the input field after sending
      emailController.clear();

      // Navigate to login after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    } on FirebaseAuthException catch (e) {
      setState(() => isLoading = false);

      String message = 'An error occurred. Please try again.';
      if (e.code == 'user-not-found') {
        message = 'No user found with this email.';
      } else if (e.code == 'invalid-email') {
        message = 'Please enter a valid email address.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: Stack(
        children: [
          // Background
          BackgroundContainer(
            width: 0,
            radius: 0,
            child: Padding(
              padding: EdgeInsets.only(top: 300.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),

                      // Email Field
                      InputField(
                        label: 'Email Address',
                        hintText: 'Enter your email',
                        icon: Icons.email,
                        obscureText: false,
                        controller: emailController,
                      ),

                      SizedBox(height: 40.h),

                      // Send Button (with loading state)
                      CustomElevatedButton(
                        text: isLoading ? 'Sending...' : 'Send Reset Link',
                        onPressed: isLoading ? null : () => _sendPasswordResetEmail(),
                        height: 40.h,
                        width: 300.w,
                        backgroundColor: AppColors.logocolor,
                        textColor: Colors.white,
                        borderRadius: 10.r,
                      ),
                      SizedBox(height: 40.h),

                      // Signup Navigation
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupScreen()),
                          );
                        },
                        child: Text(
                          "You don’t have an account?",
                          style: TextStyle(
                            color: AppColors.logocolor,
                            fontFamily: 'Urbanist',
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Top Container
          Container(
            height: 250.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.logocolor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.r),
                bottomRight: Radius.circular(20.r),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 50.h),
              child: Column(
                children: [
                  Text(
                    "Forget Password",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    "We’ll send a password reset link to your email",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Urbanist',
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Logo Box
          Positioned(
            top: 190.h,
            left: 140.w,
            child: Container(
              height: 110.h,
              width: 120.w,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: AppColors.logocolor,
                  width: 4,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.asset(
                AppImages.applogo,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
