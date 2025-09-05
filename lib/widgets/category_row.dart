import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:talk/constants/colors.dart';

class CategoryData {
  final String title;
  final String imagePath;

  CategoryData({
    required this.title,
    required this.imagePath,
  });
}

class CategoryRowWidget extends StatelessWidget {
  final List<CategoryData> categories;
  final Function(String, String, List<Color>) onCardTap;

  const CategoryRowWidget({
    super.key,
    required this.categories,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
            categories.map((category) => _buildCategoryCard(category)).toList(),
      ),
    );
  }

  Widget _buildCategoryCard(CategoryData data) {
    return GestureDetector(
      onTap: () => onCardTap(
        data.title,
        data.imagePath,
        [AppColors.bgcolor, AppColors.bgcolor],
      ),
      child: Container(
        height: 110.h,
        width: 100.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 5.h, left: 5.w, right: 3.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data.title,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Urbanist',
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: SvgPicture.asset(
                  data.imagePath,
                  fit: BoxFit.cover,
                  color: Colors.black,
                  height: 40.h,
                  width: 40.w,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
