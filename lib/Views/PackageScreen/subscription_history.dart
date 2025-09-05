import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/Views/PackageScreen/package_screen.dart';
import 'package:talk/constants/colors.dart';
import 'package:talk/constants/reusable_button.dart';

class SubscriptionHistory extends StatelessWidget {
  const SubscriptionHistory({super.key});

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
            'Subscription History',
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return _buildTransactionTile(
                    context,
                    'Transaction #${index + 1}',
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
    return Column(
      children: [
        Container(
          height: 100.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: AppColors.logocolor,
          ),
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
            leading: Icon(icon, color: iconColor, size: 24.w),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: 'Urbanist',
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              date,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
                fontFamily: 'Urbanist',
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '\$$amount ',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'coins 10',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ],
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'View':
                        // Handle view action
                        break;
                      case 'Delete':
                        // Handle delete action
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'View',
                      child: Text('View'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Delete',
                      child: Text('Delete'),
                    ),
                  ],
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}
