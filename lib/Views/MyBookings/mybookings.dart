import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/Views/MyBookings/BookingTabs/accepted_tab.dart';
import 'package:talk/constants/colors.dart';

class MyBookingScreen extends StatefulWidget {
  const MyBookingScreen({super.key});

  @override
  State<MyBookingScreen> createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'My Bookings',
            style: TextStyle(
              fontSize: 22.sp,
              color: Colors.white,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: AppColors.logocolor,
      ),
      body: Column(
        children: [
          SizedBox(height: 20.h),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                AcceptedTab(),
                AcceptedTab(),
                AcceptedTab(),
                AcceptedTab(),
                AcceptedTab(),
                AcceptedTab(),
              ],
            ),
          ),
        ],
      ),
      // drawer: const DrawerView(),
    );
  }

  Widget _buildTabBar() {
    return SizedBox(
      height: 50.h,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicator: BoxDecoration(
          color: AppColors.logocolor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        tabs: [
          _buildTab('Received', 0),
          _buildTab('Accepted', 1),
          _buildTab('On the Way', 2),
          _buildTab('Ready', 3),
          _buildTab('In Progress', 4),
          _buildTab('Completed', 5),
        ],
      ),
    );
  }

  Widget _buildTab(
    String text,
    int index,
  ) {
    bool isSelected = _tabController.index == index;

    return GestureDetector(
      onTap: () {
        _tabController.animateTo(index);
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.logocolor : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 8.w),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontFamily: 'Urbanist',
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
