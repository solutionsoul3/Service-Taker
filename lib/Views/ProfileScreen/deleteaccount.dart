import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/constants/colors.dart';
import 'package:talk/constants/reusable_button.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final bool _obscureOldPassword = true;
  final bool _obscureNewPassword = true;
  final bool _obscureConfirmPassword = true;

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
              SizedBox(
                height: 20.h,
              ),
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
                      SizedBox(
                        height: 10.h,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                            height: 100.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(70.r),
                                border: Border.all(
                                    width: 2, color: AppColors.logocolor)),
                            child: Icon(CupertinoIcons.exclamationmark,
                                size: 50.sp, color: AppColors.logocolor)),
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Once you deleted this account,there is no going back.please be certain',
                              style: TextStyle(
                                color: AppColors.logocolor,
                                fontFamily: 'Urbanist',
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 80.h,
              ),
              Center(
                child: CustomElevatedButton(
                  text: 'Delete',
                  onPressed: () {},
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
