import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Constants/colors.dart';

class AboutScreenUs extends StatefulWidget {
  const AboutScreenUs({super.key});

  @override
  State<AboutScreenUs> createState() => _AboutScreenUsState();
}

class _AboutScreenUsState extends State<AboutScreenUs> {
  String? privacyText;
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    fetchPrivacyPolicy();
  }

  Future<void> fetchPrivacyPolicy() async {
    try {
      QuerySnapshot adminSnapshot =
          await FirebaseFirestore.instance.collection('Admin').get();
      if (adminSnapshot.docs.isNotEmpty) {
        // Assuming you want to get the first document from the Admin collection
        DocumentSnapshot adminDoc = adminSnapshot.docs.first;
        QuerySnapshot categorySnapshot =
            await adminDoc.reference.collection('aboutus').get();

        if (categorySnapshot.docs.isNotEmpty) {
          // Assuming you want to get the first document from the privacypolicy collection
          privacyText = categorySnapshot.docs.first['about'];
        }
      }
    } catch (e) {
      print('Error fetching privacy policy: $e'); // Handle error as needed
    } finally {
      setState(() {
        isLoading = false; // Update loading state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'About Us',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Urbanist',
          ),
        ),
        backgroundColor: AppColors.logocolor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15.w, right: 15.w),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 40.h),
                    Center(
                      child: Text(
                        privacyText ?? "No privacy policy available.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                    ),
                    SizedBox(height: 60.h),
                  ],
                ),
              ),
      ),
    );
  }
}
