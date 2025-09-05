import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/constants/colors.dart';

class BackgroundContainer extends StatelessWidget {
  final Widget child;

  const BackgroundContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgcolor,
      width: MediaQuery.of(context).size.width,
      child: child,
    );
  }
}

class InputField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextEditingController controller; // Add this line

  const InputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.icon,
    required this.controller, // Add this line
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, top: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Urbanist',
                fontSize: 13.sp,
              ),
            ),
            Row(
              children: [
                Icon(icon, size: 20.sp, color: Colors.grey),
                SizedBox(width: 10.w),
                Expanded(
                  child: TextFormField(
                    controller: controller, // Add the controller here
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyle(
                        fontFamily: 'Urbanist',
                        color: Colors.grey.shade600,
                        fontSize: 14.sp,
                      ),
                      border: InputBorder.none,
                    ),
                    obscureText: obscureText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TextFieldWithIcon extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final double iconSize; // Added iconSize property.
  final TextEditingController controller; // Add the controller property.

  const TextFieldWithIcon({
    super.key,
    required this.labelText,
    required this.icon,
    required this.hintText,
    required this.controller, // Controller is required now.
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.iconSize = 24.0, // Default icon size.
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Urbanist',
            fontSize: 15.sp, // Use ScreenUtil for responsive font size.
          ),
        ),
        const SizedBox(
            height: 8.0), // Add some spacing between label and text field.
        Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.grey,
                size: iconSize, // Set the icon size.
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: TextField(
                  controller: controller, // Use the controller here.
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: Colors.grey, // Set the hint text color.
                      fontSize: 14.sp, fontFamily: 'Urbanist',
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 8.0), // Adjust padding as needed.
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
