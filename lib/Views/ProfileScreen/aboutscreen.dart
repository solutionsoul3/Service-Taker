import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/Models/UserModel.dart';
import 'package:talk/Views/Drawer/drawerscreen.dart';
import 'package:talk/Views/ProfileScreen/deleteaccount.dart';
import 'package:talk/Views/ProfileScreen/profiledetails.dart';
import 'package:talk/constants/colors.dart';
import 'package:talk/constants/image.dart';
import 'package:talk/utility/user_service.dart';
import 'package:talk/widgets/textfields.dart';

import '../auth/login_screen.dart'; // ✅ Import LoginScreen

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    UserService userService = UserService();
    UserModel? user = await userService.getUserDetails();
    setState(() {
      currentUser = user;
    });
  }

  void _onTileTap(String actionTitle) {
    switch (actionTitle) {
      case 'My Profile':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileDetails()),
        );
        break;
      case 'Delete Account':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DeleteAccount()),
        );
        break;
      case 'logout':
        _logout(); // ✅ fixed
        break;
      default:
        print('$actionTitle tapped');
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // ❌ Cancel
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog first
              await FirebaseAuth.instance.signOut(); // ✅ Sign out user

              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Logged out successfully"),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text(
              "Yes",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, String actionTitle) {
    return ListTile(
      leading: Icon(icon, color: AppColors.logocolor),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Urbanist',
          fontSize: 13.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16.sp,
        color: Colors.grey,
      ),
      onTap: () => _onTileTap(actionTitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.bgcolor,
      drawer: const DrawerView(),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            BackgroundContainer(
              child: Padding(
                padding: EdgeInsets.only(top: 230.h),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      SizedBox(height: 40.h),
                      Container(
                        height: 200.h,
                        width: 350.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Column(
                          children: [
                            _buildListTile(Icons.person, "My Profile", "My Profile"),
                            _buildListTile(Icons.delete, "Delete Account", "Delete Account"),
                            _buildListTile(Icons.logout, "Log out", "logout"),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 200.h,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.logocolor, AppColors.logocolor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.r),
                  bottomRight: Radius.circular(20.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white),
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                        ),
                        Text(
                          'Account',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications_active, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      currentUser != null ? currentUser!.name : 'Loading...',
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                    ),
                    Text(
                      currentUser != null ? currentUser!.email : 'Loading...',
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        color: Colors.white,
                        fontSize: 18.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 150.h,
              left: 140.w,
              child: Container(
                height: 110.h,
                width: 120.w,
                decoration: BoxDecoration(
                  color: AppColors.logocolor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.logocolor, width: 4),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: currentUser == null
                      ? const Center(child: CircularProgressIndicator())
                      : Image.network(
                    currentUser!.imageUrl ?? "",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        AppImages.applogo,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
