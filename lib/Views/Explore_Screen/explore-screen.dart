import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/Models/UserModel.dart';
import 'package:talk/Views/ExploreCategory/explorecategory.dart';
import 'package:talk/constants/colors.dart';
import 'package:talk/constants/image.dart';
import 'package:talk/utility/user_service.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  UserModel? currentUser;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // All available service categories
  static const List<Map<String, String>> _allCategories = [
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
    {"catename": "Carpenter", "imageURL": "assets/icons/carpenter.png"},
    {"catename": "Gardener", "imageURL": "assets/icons/gardener.png"},
    {"catename": "AC Repair", "imageURL": "assets/icons/ac_repair.png"},
    {"catename": "Appliance Repair", "imageURL": "assets/icons/appliance_repair.png"},
    {"catename": "Pest Control", "imageURL": "assets/icons/pest_control.png"},
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

  // Filter categories based on search query
  List<Map<String, String>> get _filteredCategories {
    if (_searchQuery.isEmpty) {
      return _allCategories;
    }

    return _allCategories.where((category) {
      return category['catename']!
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 180.h,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Container(
              margin: EdgeInsets.only(left: 16.w, top: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4.r,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded,
                    color: AppColors.logocolor, size: 20.sp),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(bottom: 16.h),
              centerTitle: true,
              title: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6.r,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'Explore Services',
                  style: TextStyle(
                    color: AppColors.logocolor,
                    fontFamily: 'Urbanist',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.logocolor.withOpacity(0.8),
                      AppColors.logocolor.withOpacity(0.4),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Search Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8.r,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 15.h, horizontal: 20.w),
                    border: InputBorder.none,
                    hintText: 'Search services...',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Urbanist',
                      fontSize: 14.sp,
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    )
                        : null,
                  ),
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ),
          ),

          // Results count
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Text(
                "${_filteredCategories.length} Services Available",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                  fontFamily: 'Urbanist',
                ),
              ),
            ),
          ),

          // Categories Grid
          _filteredCategories.isEmpty
              ? SliverToBoxAdapter(
            child: Container(
              height: 300.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off_rounded,
                      size: 60.sp, color: Colors.grey[400]),
                  SizedBox(height: 15.h),
                  Text(
                    "No services found",
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Urbanist',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Try a different search term",
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Urbanist',
                      fontSize: 14.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
              : SliverPadding(
            padding:
            EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            sliver: SliverGrid(
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 15.w,
                mainAxisSpacing: 15.h,
                childAspectRatio: 0.7, // FIX: more vertical space
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final category = _filteredCategories[index];
                  return _buildCategoryCard(category, context);
                },
                childCount: _filteredCategories.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Category Card Widget
  Widget _buildCategoryCard(
      Map<String, String> category, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExploreCategory(category: category),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // FIX: prevents overflow
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Category Icon
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: AppColors.logocolor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  category['imageURL']!,
                  width: 30.w,
                  height: 30.h,
                  color: AppColors.logocolor,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.category_rounded,
                      size: 30.sp,
                      color: AppColors.logocolor,
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 8.h),

            // Category Name
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Text(
                category['catename']!,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontFamily: 'Urbanist',
                ),
              ),
            ),

            // Explore Button
            Container(
              margin: EdgeInsets.only(top: 6.h),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: AppColors.logocolor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                'Explore',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: AppColors.logocolor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
