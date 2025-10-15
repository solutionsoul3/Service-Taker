import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/Models/UserModel.dart';
import 'package:talk/Views/Drawer/drawerscreen.dart';
import 'package:talk/constants/colors.dart';
import 'package:talk/constants/image.dart';
import 'package:talk/widgets/image_carousel.dart';
import 'package:talk/widgets/sectiontitle.dart';
import '../../Controller/user-contoller.dart';
import '../../widgets/categoryItem_row.dart';
import '../../widgets/popular-servie-card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final UserController _userController = UserController();
  UserModel? currentUser;

  static const _carouselImages = [
    AppImages.plumber,
    AppImages.handman,
    AppImages.service,
    AppImages.construction,
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
    {
      "catename": "Internet Provider",
      "imageURL": "assets/icons/internet_provider.png"
    },
    {"catename": "Gas Provider", "imageURL": "assets/icons/gas_provider.png"},
  ];

  static const _popularServices = [
    {"catename": "Electrician", "imageURL": "assets/images/services/electricain.jpeg"},
    {"catename": "Mechanic", "imageURL": "assets/images/services/plumber.jpeg"},
    {"catename": "Painter", "imageURL": "assets/images/services/handyman.jpeg"},
    {
      "catename": "Internet Provider",
      "imageURL": "assets/images/services/construction.jpeg"
    }
  ];

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    final user = await _userController.getCurrentUser();
    if (mounted) setState(() => currentUser = user);
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
            _Header(
              scaffoldKey: _scaffoldKey,
              currentUser: currentUser,
            ),
            SizedBox(height: 20.h),
            ImageCarousel(imagePaths: _carouselImages, height: 240.h),
            SizedBox(height: 15.h),
            SectionTitle(title: 'Categories', actionText: 'See all'),
            SizedBox(height: 8.h),
            SizedBox(
              height: 110.h,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (_, i) => CategoryItem(category: _categories[i]),
              ),
            ),
            SizedBox(height: 15.h),
            SectionTitle(title: 'Popular Services', actionText: 'View all'),
            SizedBox(height: 16.h),
            SizedBox(
              height: 210.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                itemCount: _popularServices.length,
                separatorBuilder: (_, __) => SizedBox(width: 16.w),
                itemBuilder: (_, i) {
                  final category = _popularServices[i] as Map<String, dynamic>;
                  return PopularServiceCard(category: category);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// ================= HEADER =================
class _Header extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final UserModel? currentUser;

  const _Header({required this.scaffoldKey, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.r)),
        gradient: const LinearGradient(
          colors: [AppColors.logocolor, Color(0xFF4CAF50)],
        ),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _topBar(context),
          SizedBox(height: 12.h),
          _userInfo(),
          SizedBox(height: 15.h),
          _searchBar(),
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
          ),
          // GestureDetector(
          //   onTap: () => Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (_) => const NotificationScreen()),
          //   ),
          //   child: const Icon(Icons.notifications, color: Colors.white, size: 28),
          // )
        ],
      );
  Widget _userInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 26.r,
          backgroundColor: Colors.grey.shade300,
          backgroundImage: (currentUser?.imageUrl != null &&
              currentUser!.imageUrl!.isNotEmpty)
              ? NetworkImage(currentUser!.imageUrl!)
              : null,
          child: (currentUser?.imageUrl == null || currentUser!.imageUrl!.isEmpty)
              ? const Icon(Icons.person, color: Colors.white, size: 28)
              : null,
        ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome back,",
              style: TextStyle(
                color: Colors.white,
                fontSize: 23.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              currentUser?.name ?? "Loading...",
              style: TextStyle(
                fontSize: 17.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _searchBar() => Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          children: [
            SizedBox(width: 14.w),
            const Icon(Icons.search, color: AppColors.logocolor),
            SizedBox(width: 6.w),
            Expanded(
              child: TextField(
                textAlignVertical:
                    TextAlignVertical.center, // ✅ Centers text vertically
                decoration: InputDecoration(
                  isCollapsed: true, // ✅ Removes default padding
                  contentPadding: EdgeInsets.zero, // ✅ Ensures full centering
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
