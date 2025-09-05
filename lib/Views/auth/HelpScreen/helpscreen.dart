import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/constants/colors.dart';

class HelpScreen extends StatelessWidget {
  // Replace these with your actual contact details
  final String companyName = 'Your Company Name';
  final String phoneNumber = '+1234567890';
  final String emailAddress = 'info@yourcompany.com';
  final String landlineContact = '+0987654321';
  final String website = 'https://www.yourcompany.com';

  const HelpScreen({super.key});

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
            'Help Screen',
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Container(
            height: 50.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: AppColors.logocolor),
            child: ListTile(
              leading: const Icon(Icons.business, color: Colors.blue),
              title: Text(
                companyName,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.white,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            height: 50.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: AppColors.logocolor),
            child: ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: Text(
                phoneNumber,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.white,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                ),
              ),
              // onTap: () => _launchURL('tel:$phoneNumber'),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            height: 50.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: AppColors.logocolor),
            child: ListTile(
              leading: const Icon(Icons.email, color: Colors.red),
              title: Text(
                emailAddress,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.white,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                ),
              ),
              // onTap: () => _launchURL('mailto:$emailAddress'),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            height: 50.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: AppColors.logocolor),
            child: ListTile(
              leading: const Icon(Icons.phone_in_talk, color: Colors.orange),
              title: Text(
                landlineContact,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.white,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                ),
              ),
              // onTap: () => _launchURL('tel:$landlineContact'),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            height: 50.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: AppColors.logocolor),
            child: ListTile(
              leading: const Icon(Icons.web, color: Colors.purple),
              title: Text(
                website,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.white,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                ),
              ),
              // onTap: () => _launchURL(website),
            ),
          ),
        ],
      ),
    );
  }
}
