import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:talk/constants/colors.dart';
import 'package:talk/constants/image.dart';

class PackageScreen extends StatefulWidget {
  const PackageScreen({super.key});

  @override
  _PackageScreenState createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final gradients = [
      [const Color(0xfffd5ad57), Colors.white],
      [const Color(0xfffd5ad57), Colors.white],
      [const Color(0xfffd5ad57), Colors.white]
    ];

    final plans = ['Weekly', 'Monthly', 'Yearly'];
    final coins = [100, 500, 1200];
    final prices = ['\$4.99', '\$19.99', '\$49.99'];
    final descriptions = [
      'Get access to premium features weekly.',
      'Best value! Unlock features for a month.',
      'Save more with the yearly subscription.',
    ];

    final icons = [
      AppImages.coinicon,
      AppImages.coinicon,
      AppImages.coinicon,
    ];

    final contents = List.generate(3, (index) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icons[index],
            height: 60.h,
            width: 60.w,
          ),
          SizedBox(height: 10.h),
          Text(
            '${plans[index]} Plan',
            style: TextStyle(
              fontSize: 24.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'Urbanist',
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            '${coins[index]} Coins',
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.black,
              fontFamily: 'Urbanist',
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            prices[index],
            style: TextStyle(
              fontSize: 22.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'Urbanist',
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              descriptions[index],
              style: TextStyle(
                  fontFamily: 'Urbanist', fontSize: 16.sp, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () {
              print('Purchased ${plans[index]} Plan');
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: AppColors.logocolor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Text(
                'Buy Now',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      );
    });

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
            'Subscription Plans',
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Text(
              'Get Subscription Plans According to you choice and enjoy our service :',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey,
                fontFamily: 'Urbanist',
              ),
            ),
            SizedBox(
              height: 500.h,
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: contents.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(20.0),
                    width: 300.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradients[index],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10.r,
                          offset: Offset(0, 5.h),
                        ),
                      ],
                    ),
                    child: contents[index],
                  );
                },
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: _currentIndex == index ? 16.w : 8.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? AppColors.logocolor
                        : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
