import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/Models/UserModel.dart';
import 'package:talk/Views/AboutUs/AboutUs.dart';
import 'package:talk/Views/FeedBack/feedback.dart';
import 'package:talk/Views/PrivacyPolicy/PrivacyPolicy.dart';
import 'package:talk/Views/auth/HelpScreen/helpscreen.dart';
import 'package:talk/Views/auth/login_screen.dart';

import '../../../../Constants/colors.dart';
import '../../Controller/user-contoller.dart';
import '../../constants/image.dart';

class DrawerView extends StatefulWidget {
  const DrawerView({super.key});

  @override
  State<DrawerView> createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> {
  UserModel? currentUser;
  final UserController _userController = UserController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// Load current user from Firestore using UserController
  Future<void> _loadUserData() async {
    UserModel? user = await _userController.getCurrentUser();
    if (mounted) {
      setState(() => currentUser = user);
    }
  }

  /// Logout confirmation dialog
  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                // 👉 Add FirebaseAuth signOut if needed
                // await FirebaseAuth.instance.signOut();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                );
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  /// Drawer Header with user info
  Widget _drawerHeader() {
    return DrawerHeader(
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(color: AppColors.logocolor),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 70.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40.r,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: const AssetImage(AppImages.applogo),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    currentUser?.name ?? 'Loading...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    currentUser?.email ?? 'Loading...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Drawer ListTile
  Widget _listTile(String title, IconData icon, {VoidCallback? onTap}) {
    return ListTile(
      title: Row(
        children: [
          Icon(icon, size: 24.sp),
          SizedBox(width: 12.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _drawerHeader(),

          Padding(
            padding: EdgeInsets.only(left: 10.0.w, top: 10.h),
            child: Text(
              'Application preferences',
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.grey,
              ),
            ),
          ),

          _listTile('Feed Back', Icons.feedback,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const FeedBackScreen()))),
          _listTile('Privacy Policy', Icons.policy,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const PrivacyPolicy()))),
          _listTile('About Us', Icons.info,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AboutScreenUs()))),
          _listTile('Help', Icons.help,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const HelpScreen()))),
          _listTile('Settings', Icons.settings,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const HelpScreen()))),

          /// Logout
          _listTile('Logout', Icons.logout, onTap: _logout),
        ],
      ),
    );
  }
}
