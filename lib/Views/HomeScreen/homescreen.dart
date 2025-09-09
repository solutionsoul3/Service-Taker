import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/Models/UserModel.dart';
import 'package:talk/Views/Drawer/drawerscreen.dart';
import 'package:talk/Views/ExploreCategory/explorecategory.dart';
import 'package:talk/Views/MyBookings/NotificationScreen/notificationscreen.dart';
import 'package:talk/constants/colors.dart';
import 'package:talk/constants/image.dart';
import 'package:talk/utility/user_service.dart';
import 'package:talk/widgets/image_carousel.dart';
import 'package:talk/widgets/sectiontitle.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UserModel? currentUser;

  // Constants
  static const _carouselImages = [
    'assets/images/homepics/slider1.jpg',
    'assets/images/homepics/slider4.jpg',
    'assets/images/homepics/slider2.jpg',
    'assets/images/homepics/slider3.jpg',
  ];

  static const _categories = [
    {"catename": "Electrician", "imageURL": "assets/icons/electrician.png"},
    {"catename": "Plumber", "imageURL": "assets/icons/plumber.png"},
    {"catename": "Painter", "imageURL": "assets/icons/painter.png"},
    {"catename": "House Cleaner", "imageURL": "assets/icons/house_cleaner.png"},
    {"catename": "Tow Truck", "imageURL": "assets/icons/tow_truck.png"},
    {"catename": "Fumigator", "imageURL": "assets/icons/fumigator.png"},
    {"catename": "Mechanic", "imageURL": "assets/icons/mechanic.png"},
    {"catename": "Movers", "imageURL": "assets/icons/movers.png"},
    {"catename": "Internet Provider", "imageURL": "assets/icons/internet_provider.png"},
    {"catename": "Gas Provider", "imageURL": "assets/icons/gas_provider.png"},
  ];

  // Updated to use JPG service images instead of PNG icons
  static const _popularServices = [
    {'title': 'Plumber', 'img': AppImages.plumber, 'rating': 4.8},
    {'title': 'Handyman', 'img': AppImages.handman, 'rating': 4.7},
    {'title': 'Electrician', 'img': AppImages.service, 'rating': 4.9},
    {'title': 'Construction', 'img': AppImages.construction, 'rating': 4.6},
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userService = UserService();
    final user = await userService.getUserDetails();
    setState(() {
      currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.bgcolor,
      drawer: const DrawerView(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 20.h),
            ImageCarousel(imagePaths: _carouselImages, height: 240.h),
            SizedBox(height: 15.h),
            SectionTitle(
              title: 'Categories',
              actionText: 'See all',
              onActionTap: () {},
            ),
            SizedBox(height: 8.h),
            _buildCategoryRow(),
            SizedBox(height: 15.h),
            _buildPopularServices(),
          ],
        ),
      ),
    );
  }

  /// Header with gradient, avatar, notifications
  Widget _buildHeader() {
    return Container(
      height: 220.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
        gradient: const LinearGradient(
          colors: [AppColors.logocolor, Color(0xFF4CAF50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(),
            SizedBox(height: 12.h),
            _buildUserInfo(),
            SizedBox(height: 15.h),
            _buildSearchBar(),
          ],
        ),
      ),
    );
  }

  /// Top bar with menu and notification icons
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.white, size: 28),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              ),
              child: const Icon(Icons.notifications, color: Colors.white, size: 28),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                height: 10.h,
                width: 10.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  /// User information section
  Widget _buildUserInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 26.r,
          backgroundImage: (currentUser?.imageUrl != null && currentUser!.imageUrl!.isNotEmpty)
              ? NetworkImage(currentUser!.imageUrl!)
              : const AssetImage("assets/images/profile_placeholder.png") as ImageProvider,
        ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome back,", style: TextStyle(color: Colors.white70, fontSize: 13.sp)),
            Text(
              currentUser != null ? currentUser!.name : "Loading...",
              style: TextStyle(
                fontSize: 17.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: "Urbanist",
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Search Bar
  Widget _buildSearchBar() {
    return Container(
      height: 45.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(width: 14.w),
          const Icon(Icons.search, color: AppColors.logocolor),
          SizedBox(width: 6.w),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search services...",
                hintStyle: TextStyle(fontSize: 13.sp, color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          const Icon(Icons.filter_alt_outlined, color: AppColors.logocolor),
          SizedBox(width: 14.w),
        ],
      ),
    );
  }

  /// Categories Horizontal Row
  Widget _buildCategoryRow() {
    return SizedBox(
      height: 110.h,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return Container(
            width: 90.w,
            margin: EdgeInsets.only(right: 10.w),
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.grey.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExploreCategory(category: category),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCategoryImage(category["imageURL"]!),
                  SizedBox(height: 8.h),
                  Text(
                    category["catename"]!,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Urbanist",
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Category image with error handling
  Widget _buildCategoryImage(String imagePath) {
    return Image.asset(
      imagePath,
      height: 45.h,
      width: 45.w,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: 45.h,
          width: 45.w,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.error_outline, color: Colors.grey[400], size: 24.sp),
        );
      },
    );
  }

  /// Popular Services Section
  Widget _buildPopularServices() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: 'Popular Services',
            actionText: 'View all',
            onActionTap: () {},
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 210.h, // Increased height for better visuals
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _popularServices.length,
              separatorBuilder: (_, __) => SizedBox(width: 16.w),
              itemBuilder: (context, index) {
                final service = _popularServices[index];
                return _buildServiceCard(
                  service['title'] as String,
                  service['img'] as String,
                  service['rating'] as double,

                );
              },
            ),
          )
        ],
      ),
    );
  }

  /// Attractive Service Card with modern design

  /// Elegant Service Card with minimalist design
  Widget _buildServiceCard(String title, String imagePath, double rating) {
    return Container(
      width: 160.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service Image
          Stack(
            children: [
              // Image container
              Container(
                height: 120.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                  color: Colors.grey[100],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.r),
                            topRight: Radius.circular(16.r),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[400],
                            size: 32.sp,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Subtle overlay
              Container(
                height: 120.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.1),
                    ],
                  ),
                ),
              ),

              // Rating badge
              Positioned(
                bottom: 10.h,
                left: 10.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 14.sp),
                      SizedBox(width: 4.w),
                      Text(
                        rating.toString(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Service Info
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Urbanist",
                    color: Colors.black87,
                    letterSpacing: 0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),

                // Service details
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14.sp,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "30-60 mins",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    Spacer(),
                    Text(
                      "•",
                      style: TextStyle(
                        color: Colors.grey[400],
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.thumb_up,
                      size: 14.sp,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "98%",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}