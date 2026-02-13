import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Constants/colors.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔹 Fetch Privacy Policy directly from Firestore
  Future<Map<String, dynamic>?> _getPolicy() async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection("PrivacyPolicy")
          .doc("policy_document")
          .get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      } else {
        debugPrint("Privacy Policy document not found.");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching privacy policy: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.logocolor,
        elevation: 0,
        title: const Text(
          "Privacy Policy",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _getPolicy(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(color: AppColors.logocolor));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text(
                "Privacy Policy not available.",
                style: TextStyle(color: Colors.black),
              ),
            );
          }

          final data = snapshot.data!;
          final sections = (data["sections"] ?? []) as List<dynamic>;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    data["heading"] ??
                        "Privacy Policy",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.logocolor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20.h),
                for (var section in sections) ...[
                  Text(
                    section["heading"] ?? "",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.logocolor,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    section["content"] ?? "",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 15.h),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
