import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/constants/colors.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  final double height;
  final double? width;

  const CustomContainer({
    super.key,
    required this.child,
    required this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width ?? MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: AppColors.bgcolor,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
