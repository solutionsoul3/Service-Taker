import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;

  const CustomRow({
    super.key,
    required this.title,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null) Icon(icon, color: Colors.grey),
            if (icon != null) SizedBox(width: 8.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Urbanist',
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey,
            fontFamily: 'Urbanist',
          ),
        ),
      ],
    );
  }
}
