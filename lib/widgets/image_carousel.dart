import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/constants/colors.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> imagePaths;
  final Duration autoSlideInterval;
  final bool showIndicators;
  final bool showNavigationArrows;
  final BoxFit imageFit;
  final double height;

  const ImageCarousel({
    super.key,
    required this.imagePaths,
    this.autoSlideInterval = const Duration(seconds: 4),
    this.showIndicators = true,
    this.showNavigationArrows = true,
    this.imageFit = BoxFit.cover,
    this.height = 280, // default height (increased from 220)
  });

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _autoSlideTimer;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _startAutoSlide();
    _pageController.addListener(_pageListener);
  }

  void _pageListener() {
    setState(() {
      _currentPage = _pageController.page?.round() ?? 0;
    });
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(widget.autoSlideInterval, (timer) {
      if (widget.imagePaths.isNotEmpty) {
        int nextPage = (_currentPage + 1) % widget.imagePaths.length;
        _animateToPage(nextPage);
      }
    });
  }

  void _animateToPage(int page) {
    _animationController.reset();
    _pageController
        .animateToPage(
      page,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    )
        .then((_) => _animationController.forward());
  }

  void _goToNextPage() {
    _animateToPage((_currentPage + 1) % widget.imagePaths.length);
    _startAutoSlide();
  }

  void _goToPreviousPage() {
    _animateToPage(
        (_currentPage - 1 + widget.imagePaths.length) % widget.imagePaths.length);
    _startAutoSlide();
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.removeListener(_pageListener);
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildImageCarousel(),
        if (widget.showIndicators) SizedBox(height: 18.h),
        if (widget.showIndicators) _buildPageIndicator(),
      ],
    );
  }

  Widget _buildImageCarousel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: SizedBox(
        height: widget.height.h, // ⬅️ increased height
        child: Stack(
          alignment: Alignment.center,
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.imagePaths.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = 1.0;
                    if (_pageController.position.haveDimensions) {
                      value = _pageController.page! - index;
                      value = (1 - (value.abs() * 0.3)).clamp(0.7, 1.0);
                    }

                    return Center(
                      child: SizedBox(
                        height: Curves.easeOut.transform(value) * widget.height.h,
                        width: Curves.easeOut.transform(value) *
                            MediaQuery.of(context).size.width *
                            0.9,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 18,
                          spreadRadius: 1,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: Image.asset(
                        widget.imagePaths[index],
                        fit: widget.imageFit,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.broken_image,
                              color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Navigation arrows
            if (widget.showNavigationArrows && widget.imagePaths.length > 1)
              Positioned(
                left: 0,
                child: _navButton(Icons.arrow_back_ios, _goToPreviousPage),
              ),
            if (widget.showNavigationArrows && widget.imagePaths.length > 1)
              Positioned(
                right: 0,
                child: _navButton(Icons.arrow_forward_ios, _goToNextPage),
              ),
          ],
        ),
      ),
    );
  }

  Widget _navButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Container(
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18.sp, color: AppColors.logocolor),
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.imagePaths.length, (index) {
        bool isActive = _currentPage == index;
        return GestureDetector(
          onTap: () => _animateToPage(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            height: 8.h,
            width: isActive ? 24.w : 8.w,
            decoration: BoxDecoration(
              color: isActive ? AppColors.logocolor : Colors.grey.shade400,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: isActive
                  ? [
                BoxShadow(
                  color: AppColors.logocolor.withOpacity(0.5),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ]
                  : null,
            ),
          ),
        );
      }),
    );
  }
}
