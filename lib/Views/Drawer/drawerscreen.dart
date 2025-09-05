import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/Models/UserModel.dart';
import 'package:talk/Views/AboutUs/AboutUs.dart';
import 'package:talk/Views/FeedBack/feedback.dart';
import 'package:talk/Views/MyWalletScreen/wallet_screen.dart';
import 'package:talk/Views/PackageScreen/package_screen.dart';
import 'package:talk/Views/PackageScreen/subscription_history.dart';
import 'package:talk/Views/PrivacyPolicy/PrivacyPolicy.dart';
import 'package:talk/Views/auth/HelpScreen/helpscreen.dart';
import 'package:talk/utility/user_service.dart';

import '../../../../Constants/colors.dart';

class DrawerView extends StatefulWidget {
  const DrawerView({super.key});

  @override
  State<DrawerView> createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> {
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    UserService userService = UserService();
    UserModel? user = await userService.getUserDetails();
    setState(() => currentUser = user);
  }

  Widget _drawerHeader() {
    return DrawerHeader(
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(color: AppColors.logocolor),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.only(left: 70.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40.r,
                  backgroundColor: Colors.grey[300],
                  child: currentUser?.imageUrl?.isNotEmpty == true
                      ? CachedNetworkImage(
                          imageUrl: currentUser!.imageUrl!,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        )
                      : const CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              AssetImage('assets/images/homepics/user1.jpg'),
                        ),
                ),
                SizedBox(width: 12.w),
                Text(
                  currentUser?.name ?? 'Loading...',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.h),
                Text(
                  currentUser?.email ?? 'Loading...',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Urbanist',
                      fontSize: 13.sp),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _listTile(String title, IconData icon, Widget screen) {
    return ListTile(
      title: Row(
        children: [
          Icon(icon, size: 24.sp),
          SizedBox(width: 12.w),
          Text(title,
              style: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ],
      ),
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => screen)),
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
            padding: EdgeInsets.only(left: 10.0.w),
            child: Text(
              'Subscription & Payments',
              style: TextStyle(
                  fontSize: 15.sp, fontFamily: 'Urbanist', color: Colors.grey),
            ),
          ),
          _listTile('Subscriptions History', CupertinoIcons.doc_plaintext,
              const SubscriptionHistory()),
          _listTile('Subscriptions Packages', CupertinoIcons.cube_box,
              const PackageScreen()),
          _listTile('Wallets', Icons.account_balance_wallet_outlined,
              const MyWalletScreen()),
          Padding(
            padding: EdgeInsets.only(left: 10.0.w),
            child: Text(
              'Application preferences',
              style: TextStyle(
                  fontSize: 15.sp, fontFamily: 'Urbanist', color: Colors.grey),
            ),
          ),
          _listTile('Feed Back', Icons.person, const FeedBackScreen()),
          _listTile('Privacy Policy', Icons.policy, const PrivacyPolicy()),
          _listTile('About Us', Icons.person, const AboutScreenUs()),
          _listTile('Help', Icons.help, const HelpScreen()),
          _listTile('Settings', Icons.settings, const HelpScreen()),
          _listTile('Logout', Icons.logout, const HelpScreen()),
        ],
      ),
    );
  }
}
