import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:talk/Views/BottomNav/bottomnav.dart';
import 'package:talk/Views/auth/signup_screen.dart';
import 'package:talk/constants/colors.dart';
import 'package:talk/constants/image.dart';
import 'package:talk/constants/reusable_button.dart';
import 'package:talk/widgets/textfields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  // Controllers for email and password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> loginUser() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      // Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Fetching user data from Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('User')
          .doc(userCredential.user!.uid)
          .get();

      String userName = userDoc['name']; // Get user's name from Firestore

      // Show success toast
      Fluttertoast.showToast(msg: 'Welcome, $userName!');

      // Navigate to BottomNavBar screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavBar()),
      );
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth errors
      Fluttertoast.showToast(msg: e.message ?? "Login failed");
    } catch (e) {
      Fluttertoast.showToast(msg: "An error occurred. Please try again.");
    }

    setState(() {
      _isLoading = false; // Stop loading
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            BackgroundContainer(
              child: Padding(
                padding: EdgeInsets.only(top: 300.h),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      // Email TextField
                      InputField(
                        label: 'Email Address',
                        hintText: 'Enter your email',
                        icon: Icons.email,
                        obscureText: false,
                        controller: _emailController,
                      ),
                      SizedBox(height: 20.h),
                      // Password TextField
                      InputField(
                        label: 'Password',
                        hintText: 'Enter your password',
                        icon: Icons.lock,
                        obscureText: true,
                        controller: _passwordController,
                      ),
                      SizedBox(height: 20.h),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: AppColors.logocolor,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),
                      _isLoading
                          ? const CircularProgressIndicator() // Show loading indicator
                          : CustomElevatedButton(
                              text: 'Login',
                              onPressed: loginUser, // Call login function
                              height: 40.h,
                              width: 300.w,
                              backgroundColor: AppColors.logocolor,
                              textColor: Colors.white,
                              borderRadius: 10.r,
                            ),
                      SizedBox(height: 40.h),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupScreen()),
                          );
                        },
                        child: Text(
                          "Don't have an account?",
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
            // Header
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
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "Home Services",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.sp,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "Welcome to the best services provider",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Urbanist',
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
      ),
    );
  }
}
