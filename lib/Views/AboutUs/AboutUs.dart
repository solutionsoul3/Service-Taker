import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Constants/colors.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  bool _isLoading = true;
  List<dynamic> aboutSections = [];

  @override
  void initState() {
    super.initState();
    _fetchAboutUsData();
  }

  /// ✅ Fetch About Us data from Firestore
  Future<void> _fetchAboutUsData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('about_us')
          .doc('main')
          .get();

      if (doc.exists && doc.data() != null) {
        setState(() {
          aboutSections = doc['sections'];
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("❌ Error fetching About Us data: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "About Us",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.logocolor,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : aboutSections.isEmpty
              ? const Center(child: Text("No About Us data found"))
              : SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: aboutSections
                        .map((section) => Padding(
                              padding: EdgeInsets.only(bottom: 20.h),
                              child: _buildSection(
                                number: section['number'],
                                title: section['title'],
                                content: section['content'],
                              ),
                            ))
                        .toList(),
                  ),
                ),
    );
  }

  /// ✅ Section Widget (no numbering)
  Widget _buildSection({
    required String title,
    required String content,
    required String number,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "$number. ",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.logocolor,
              ),
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.logocolor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          content,
          style: TextStyle(
            fontSize: 15.sp,
            color: Colors.black87,
            height: 1.5,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
