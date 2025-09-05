import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/constants/colors.dart';
import 'package:talk/constants/reusable_button.dart';
import 'package:talk/widgets/selectiontile.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Profile',
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
            children: [
              SizedBox(height: 20.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Change the password',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Urbanist',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.description,
                        color: Colors.grey,
                        size: 19.sp,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'Fill your older password and new password and confirm it. ',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Urbanist',
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionTitle(title: 'Old password'),
                          _buildPasswordField(
                            label: 'Enter your old password',
                            obscureText: _obscureOldPassword,
                            icon: Icons.lock_outline,
                            onVisibilityToggle: () {
                              setState(() {
                                _obscureOldPassword = !_obscureOldPassword;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: const Color.fromARGB(255, 241, 239, 239),
                      thickness: 2.h,
                    ),
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionTitle(title: 'New password'),
                          _buildPasswordField(
                            label: 'Enter your new password',
                            obscureText: _obscureNewPassword,
                            icon: Icons.lock_outline,
                            onVisibilityToggle: () {
                              setState(() {
                                _obscureNewPassword = !_obscureNewPassword;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: const Color.fromARGB(255, 241, 239, 239),
                      thickness: 2.h,
                    ),
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionTitle(title: 'Confirm password'),
                          _buildPasswordField(
                            label: 'Enter your confirm password',
                            obscureText: _obscureConfirmPassword,
                            icon: Icons.lock_outline,
                            onVisibilityToggle: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomElevatedButton(
                    text: 'Save',
                    onPressed: () {},
                    height: 40.h,
                    width: 230.w,
                    backgroundColor: AppColors.logocolor,
                    textColor: Colors.white,
                    borderRadius: 10.r,
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  CustomElevatedButton(
                    text: 'Reset',
                    onPressed: () {},
                    height: 40.h,
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
      ),
    );
  }
}

Widget _buildPasswordField({
  required String label,
  required bool obscureText,
  required IconData icon,
  required VoidCallback onVisibilityToggle,
}) {
  return TextField(
    obscureText: obscureText,
    decoration: InputDecoration(
      hintText: label,
      hintStyle: TextStyle(
        fontFamily: 'Urbanist',
        fontSize: 13.sp,
        color: Colors.grey,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide.none,
      ),
      prefixIcon: Icon(
        icon,
        color: Colors.grey,
      ),
      suffixIcon: IconButton(
        icon: Icon(
          obscureText ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ),
        onPressed: onVisibilityToggle,
      ),
    ),
  );
}
