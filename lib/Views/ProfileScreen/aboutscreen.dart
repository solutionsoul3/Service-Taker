import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/Models/UserModel.dart';
import 'package:talk/Views/Drawer/drawerscreen.dart';
import 'package:talk/Views/ProfileScreen/changepassword.dart';
import 'package:talk/Views/ProfileScreen/deleteaccount.dart';
import 'package:talk/Views/ProfileScreen/profiledetails.dart';
import 'package:talk/constants/colors.dart';
import 'package:talk/constants/image.dart';
import 'package:talk/utility/user_service.dart';
import 'package:talk/widgets/textfields.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onTileTap(String actionTitle) {
    switch (actionTitle) {
      case 'My Profile':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileDetails()),
        );
        break;
      case 'My Bookings':
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const SecondRoute()),
        // );
        break;
      case 'Change Password':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChangePassword()),
        );
        break;
      case 'Delete Account':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DeleteAccount()),
        );
        break;
      case 'My Settings':
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const SecondRoute()),
        // );
        break;
      case 'Language':
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const SecondRoute()),
        // );
        break;
      case 'theme':
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const SecondRoute()),
        // );
        break;
      case 'logout':
        _logout(); // Call a logout function or handle logout logic
        break;
      default:
        print('$actionTitle tapped');
    }
  }

  void _logout() {
    // Implement your logout logic here
    print('User logged out');
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
                        height: 260.h,
                        width: 350.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Column(
                          children: [
                            _buildListTile(
                                Icons.person, "My Profile", "My Profile"),
                            _buildListTile(
                                Icons.book, "My Bookings", "My Bookings"),
                            _buildListTile(Icons.update, "Change Password",
                                "Change Password"),
                            _buildListTile(Icons.delete, "Delete Account",
                                "Delete Account"),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Container(
                        height: 260.h,
                        width: 350.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Column(
                          children: [
                            _buildListTile(
                                Icons.settings, "Settings", "My Settings"),
                            _buildListTile(
                                Icons.language, "Language", "Language"),
                            _buildListTile(
                                Icons.light_mode, "Theme Mode", "theme"),
                            _buildListTile(Icons.logout, "Log out", "logout"),
                          ],
                        ),
                      ),
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
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
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
                          icon: const Icon(
                            Icons.notifications_active,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // Implement bell action here
                          },
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
                  border: Border.all(
                    color: AppColors.logocolor,
                    width: 4,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    AppImages.applogo,
                    fit: BoxFit.cover,
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
