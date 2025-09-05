import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/constants/colors.dart';

class ImageCarousel extends StatefulWidget {
  final PageController pageController;
  final List<String> imagePaths;

  const ImageCarousel({
    super.key,
    required this.pageController,
    required this.imagePaths,
  });

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(() {
      setState(() {
        _currentPage = widget.pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildImageCarousel(),
        SizedBox(height: 10.h),
        _buildPageIndicator(),
      ],
    );
  }

  Widget _buildImageCarousel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        height: 150.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: Colors.white,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: PageView.builder(
            controller: widget.pageController,
            itemCount: widget.imagePaths.length,
            itemBuilder: (context, index) => Image.asset(
              widget.imagePaths[index],
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.imagePaths.length,
        (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? AppColors.logocolor : Colors.grey,
          ),
        ),
      ),
    );
  }
}
