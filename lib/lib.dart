import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/constants/colors.dart';
import 'package:talk/widgets/textfields.dart';

class ExploreCategory extends StatefulWidget {
  final String title;
  final String imagePath;

  const ExploreCategory({
    super.key,
    required this.title,
    required this.imagePath,
  });

  @override
  _ExploreCategoryState createState() => _ExploreCategoryState();
}

class _ExploreCategoryState extends State<ExploreCategory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: Stack(
        children: [
          BackgroundContainer(
            child: Padding(
              padding: EdgeInsets.only(top: 350.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: const Column(
                  children: [],
                ),
              ),
            ),
          ),
          Container(
            height: 250.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.logocolor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.r),
                bottomRight: Radius.circular(20.r),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 50.h),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            widget.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                    height: 50.h,
                    width: 50.w,
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 100.w,
                          ),
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                          SizedBox(width: 8.sp),
                          Text(
                            "Lahore, Pakistan",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.location_on,
                            color: Colors.transparent,
                            size: 24.sp,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 220.h,
            left: 20.w,
            right: 20.w,
            child: SizedBox(
              height: 50.h,
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                  border: InputBorder.none,
                  hintText: 'Search...',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Urbanist',
                    fontSize: 14.sp,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  suffixIcon: const Icon(
                    Icons.filter_list,
                    color: Colors.grey,
                  ),
                ),
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          ),
          Positioned(
            top: 280.h,
            left: 20.w,
            right: 20.w,
            child: SizedBox(
              height: 50.h,
              child: Row(
                children: [
                  _buildTab('Normal', 0),
                  SizedBox(width: 10.w),
                  _buildTab('Standard', 1),
                  SizedBox(width: 10.w),
                  _buildTab('Premium', 2),
                ],
              ),
            ),
          ),
          Positioned(
            top: 330.h, // Position the TabBarView below the custom TabBar
            left: 0,
            right: 0,
            bottom: 0,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabContent('Normal'),
                _buildTabContent('Standard'),
                _buildTabContent('Premium'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build tab with custom styling
  Widget _buildTab(String text, int index) {
    bool isSelected = _tabController.index == index;

    return GestureDetector(
      onTap: () {
        _tabController.animateTo(index);
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontFamily: 'Urbanist',
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Helper method to build content for each tab
  Widget _buildTabContent(String category) {
    return Center(
      child: Text(
        '$category Content',
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}
