import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:talk/Models/UserModel.dart';
import 'package:talk/constants/colors.dart';
import 'package:talk/constants/image.dart';
import 'package:talk/constants/reusable_button.dart';
import 'package:talk/utility/user_service.dart';

class FeedBackScreen extends StatefulWidget {
  const FeedBackScreen({super.key});

  @override
  _FeedBackScreenState createState() => _FeedBackScreenState();
}

class _FeedBackScreenState extends State<FeedBackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  late UserModel? _currentUser;
  bool _hasSubmittedFeedback = false; // Track if feedback has been submitted
  bool _isLoading = true; // Track if data is still loading
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    UserService userService = UserService(); // Initialize the UserService
    UserModel? user = await userService.getUserDetails();
    setState(() {
      currentUser = user;
    });
  }

  // Fetch the currently logged-in user's details and check if feedback is submitted
  Future<void> _fetchUserDetails() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('User')
          .doc(firebaseUser.uid)
          .get();

      setState(() {
        _currentUser = UserModel.fromDocument(userDoc);
        _hasSubmittedFeedback = userDoc['Feedback'] == true;
        _isLoading = false; // Data has finished loading
      });
    }
  }

  Future<void> _submitFeedbackToAllAdmins() async {
    if (_feedbackController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your feedback')),
      );
      return;
    }

    try {
      String timestamp =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      QuerySnapshot adminDocs =
          await FirebaseFirestore.instance.collection('Admin').get();

      for (var doc in adminDocs.docs) {
        await FirebaseFirestore.instance
            .collection('Admin')
            .doc(doc.id)
            .collection('Feedbacks')
            .add({
          'feedback': _feedbackController.text,
          'userName': _currentUser?.name ?? 'Anonymous',
          'userImage': _currentUser?.imageUrl ?? '',
          'timestamp': timestamp,
        });
      }

      // Update the user's document to reflect feedback submission
      await FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'Feedback': true, // Mark feedback as submitted
      });

      _feedbackController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Feedback submitted successfully to all admins')),
      );

      setState(() {
        _hasSubmittedFeedback = true; // Update the state to reflect submission
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting feedback: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Text(
            'Feed Back',
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.white,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: AppColors.logocolor,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.logocolor,
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                children: [
                  SizedBox(height: 50.h),

                  // Check if feedback has already been submitted
                  if (_hasSubmittedFeedback)
                    Container(
                      height: 240.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.logocolor,
                            AppColors.logocolor,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0.r),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              AppImages.thanksicon,
                              height: 30.h,
                              width: 30.w,
                              color: Colors.white,
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              'FeedBack Report Card',
                              style: TextStyle(
                                fontSize: 17.sp,
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              'Already Submitted',
                              style: TextStyle(
                                fontSize: 28.sp,
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            SizedBox(height: 10.h),
                            Divider(color: Colors.white24, thickness: 1.h),
                            SizedBox(height: 10.h),
                            Text(
                              currentUser != null
                                  ? currentUser!.name
                                  : 'Loading...',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white70,
                                fontFamily: 'Urbanist',
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              currentUser != null
                                  ? currentUser!.email
                                  : 'Loading...',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white60,
                                fontFamily: 'Urbanist',
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Column(
                      children: [
                        Container(
                          height: 240.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color: Colors.white,
                            border: Border.all(
                              color: AppColors.logocolor,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(15.w),
                            child: TextField(
                              controller: _feedbackController,
                              maxLines: 8,
                              decoration: InputDecoration(
                                hintText: 'Enter your feedback here...',
                                hintStyle: TextStyle(fontSize: 14.sp),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: 'Urbanist',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 50.h),
                        CustomElevatedButton(
                          text: 'Submit',
                          onPressed: _submitFeedbackToAllAdmins,
                          height: 40.h,
                          width: 200.w,
                          backgroundColor: AppColors.logocolor,
                          textColor: Colors.white,
                          borderRadius: 10.r,
                        ),
                      ],
                    ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }
}
