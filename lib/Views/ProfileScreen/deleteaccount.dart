import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/constants/colors.dart';
import 'package:talk/constants/reusable_button.dart';

import '../auth/login_screen.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _deleteAccount() async {
    final user = _auth.currentUser;

    if (user == null) return;

    try {
      // ✅ Delete Firestore document
      await _firestore.collection("User").doc(user.uid).delete();

      // ✅ Delete Firebase Authentication account
      await user.delete();

      // ✅ Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Your account has been deleted successfully"),
            backgroundColor: Colors.red,
          ),
        );

        // Navigate to login screen after delete
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
        );}
    } catch (e) {
      // ✅ If requires reauthentication
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error deleting account: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
            "Are you sure you want to delete your account permanently? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // ❌ Cancel
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount(); // ✅ Confirm delete
            },
            child: const Text(
              "Yes, Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Delete Account',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        backgroundColor: AppColors.logocolor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 30.h),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 10.h),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 100.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(70.r),
                            border: Border.all(
                              width: 2,
                              color: AppColors.logocolor,
                            ),
                          ),
                          child: Icon(
                            CupertinoIcons.exclamationmark,
                            size: 50.sp,
                            color: AppColors.logocolor,
                          ),
                        ),
                      ),
                      SizedBox(height: 50.h),
                      Text(
                        'Delete your account',
                        style: TextStyle(
                          color: AppColors.logocolor,
                          fontFamily: 'Urbanist',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Once you delete this account, there is no going back. Please be certain.',
                        style: TextStyle(
                          color: AppColors.logocolor,
                          fontFamily: 'Urbanist',
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 80.h),
              Center(
                child: CustomElevatedButton(
                  text: 'Delete',
                  onPressed: _showDeleteDialog, // ✅ Confirmation dialog
                  height: 40.h,
                  width: 150.w,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  borderRadius: 10.r,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
