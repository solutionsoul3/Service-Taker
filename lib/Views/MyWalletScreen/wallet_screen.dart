import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:talk/Views/PackageScreen/package_screen.dart';
import 'package:talk/constants/colors.dart';
import 'package:talk/constants/image.dart';
import 'package:talk/constants/reusable_button.dart';

class MyWalletScreen extends StatelessWidget {
  const MyWalletScreen({super.key});

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
            'Wallet',
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
        child: Column(
          children: [
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppImages.cardicon,
                          height: 18.h,
                          width: 18.w,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Talk Time Balanace Card',
                          style: TextStyle(
                            fontSize: 17.sp,
                            color: Colors.white,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppImages.coinicon,
                          height: 24.h,
                          width: 24.w,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '123.45',
                          style: TextStyle(
                            fontSize: 28.sp,
                            color: Colors.white,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'Available Coins',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white70,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Divider(color: Colors.white24, thickness: 1.h),
                    SizedBox(height: 10.h),
                    Text(
                      'Account Holder: John Doe',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white70,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'Last Purchase: Sep 12, 2024',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white60,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            const Divider(
              color: Color.fromARGB(255, 218, 217, 217),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'History',
                  style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.grey,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return _buildTransactionTile(
                    context,
                    'Transaction #1',
                    '50.00',
                    'Sep 10, 2024',
                    Icons.arrow_upward,
                    Colors.green,
                  );
                },
              ),
            ),
            SizedBox(height: 20.h),
            CustomElevatedButton(
              text: 'Buy Coins ',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PackageScreen()),
                );
              },
              height: 40.h,
              width: 300.w,
              backgroundColor: AppColors.logocolor,
              textColor: Colors.white,
              borderRadius: 10.r,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTile(BuildContext context, String title,
      String amount, String date, IconData icon, Color iconColor) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      leading: Icon(icon, color: iconColor, size: 24.w),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontFamily: 'Urbanist',
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        date,
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.grey,
          fontFamily: 'Urbanist',
        ),
      ),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '\$$amount ',
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.bold,
              color: AppColors.logocolor,
            ),
          ),
          Text(
            'coins 10',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
              fontFamily: 'Urbanist',
            ),
          ),
        ],
      ),
    );
  }
}
