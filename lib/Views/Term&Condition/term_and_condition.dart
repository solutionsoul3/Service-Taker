import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Constants/colors.dart';

class TermAndConditionScreen extends StatefulWidget {
  const TermAndConditionScreen({Key? key}) : super(key: key);

  @override
  State<TermAndConditionScreen> createState() => _TermAndConditionScreenState();
}

class _TermAndConditionScreenState extends State<TermAndConditionScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔹 Get terms from Firestore directly (no default content)
  Future<Map<String, dynamic>?> _getTerms() async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection("Terms&conditions")
          .doc("terms_and_conditions")
          .get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      } else {
        debugPrint("Terms document not found.");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching terms: $e");
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
          "Terms & Conditions",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _getTerms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(color: AppColors.logocolor));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text(
                "Terms & Conditions not available.",
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
                    data["heading"] ?? "Terms & Conditions",
                    style: TextStyle(
                      fontSize: 22.sp,
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
                ]
              ],
            ),
          );
        },
      ),
    );
  }
}
