import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/constants/colors.dart';
import 'package:talk/constants/reusable_button.dart';
import 'package:talk/widgets/reusableboxdecoration.dart';

class BookedOrderDetails extends StatelessWidget {
  const BookedOrderDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            _buildBackgroundContainer(context),
            _buildHeaderImage(context),
            _buildServiceCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundContainer(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 400.h),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReusableBoxDecoration(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Customer',
                    style: reusableTextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '03377452323',
                        style: reusableTextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildIconContainer(Icons.call, 'Call'),
                          SizedBox(
                            width: 5.w,
                          ),
                          _buildIconContainer(Icons.message, 'Message'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            ReusableBoxDecoration(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Booking Deatils',
                        style: reusableTextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '#45',
                        style: reusableTextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  const Divider(),
                  SizedBox(
                    height: 10.h,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Status',
                            style: reusableTextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'Accepted',
                            style: reusableTextStyle(
                                fontSize: 16.sp, color: AppColors.appcolor),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      const Divider(),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Payment Status',
                            style: reusableTextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'Not Paid',
                            style: reusableTextStyle(
                                fontSize: 16.sp, color: AppColors.appcolor),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      const Divider(),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Hint',
                            style: reusableTextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            '',
                            style: reusableTextStyle(
                                fontSize: 16.sp, color: AppColors.appcolor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                CustomElevatedButton(
                  text: 'On the way ',
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => const BookServiceScreen()),
                    // );
                  },
                  height: 40.h,
                  width: 200.w,
                  backgroundColor: AppColors.logocolor,
                  textColor: Colors.white,
                  borderRadius: 10.r,
                ),
                SizedBox(
                  width: 20.w,
                ),
                CustomElevatedButton(
                  text: 'Decline',
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => const BookServiceScreen()),
                    // );
                  },
                  height: 35.h,
                  width: 100.w,
                  backgroundColor: Colors.grey,
                  textColor: Colors.black,
                  borderRadius: 10.r,
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 300.h,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.appcolor,
          ),
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
            child: Image.asset(
              'assets/images/map.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 25.h,
          right: 16.w,
          left: 16.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 24.sp, // Adjust the size as needed
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CustomElevatedButton(
                text: 'On Maps',
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const BookServiceScreen()),
                  // );
                },
                height: 35.h,
                width: 120.w,
                backgroundColor: AppColors.logocolor,
                textColor: Colors.white,
                borderRadius: 10.r,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(BuildContext context) {
    return Positioned(
      top: 240.h,
      left: 30.w,
      right: 30.w,
      child: Container(
        height: 130.h,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bathtub Refinishing',
                        style: TextStyle(
                          fontSize: 17.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                      Text(
                        'smarter8',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                      Text(
                        'smarter8smarter8smarter\n8smarter8smarter8',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 105.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 240, 211, 150),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          '03:50',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Urbanist',
                          ),
                        ),
                        Text(
                          '18',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Urbanist',
                          ),
                        ),
                        Text(
                          'Feb',
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Urbanist',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildIconContainer(IconData icon, String tooltip) {
  return Container(
    width: 40.w,
    height: 40.h,
    decoration: BoxDecoration(
      color: AppColors.logocolor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: IconButton(
      onPressed: () {
        // Add functionality if needed
      },
      icon: Icon(
        icon,
        color: Colors.white,
        size: 22,
      ),
      tooltip: tooltip,
    ),
  );
}
