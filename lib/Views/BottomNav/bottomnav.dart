import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:talk/Views/ChatScreen/chatscreen.dart';
import 'package:talk/Views/FavScreen/favscreen.dart';
import 'package:talk/Views/HomeScreen/homescreen.dart';
import 'package:talk/Views/MyBookings/mybookings.dart';
import 'package:talk/Views/ProfileScreen/aboutscreen.dart';
import 'package:talk/constants/colors.dart';
import 'package:talk/constants/image.dart';

import '../CallScreen/call-screen.dart';
import '../ChatScreens/chat-screen.dart';
import '../Explore_Screen/explore-screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  // List of widget pages for the BottomNavigationBar
  static final List<Widget> _pages = <Widget>[
    const HomeScreen(),
    const ExploreScreen(),

    ChatScreen(),
    UserCallScreen(),
    const AboutScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.logocolor,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppImages.homeicon,
                  height: 24.0,
                  width: 24.0,
                  color: _selectedIndex == 0
                      ? AppColors.logocolor
                      : Colors.grey,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppImages.bookingicon,
                  height: 24.0,
                  width: 24.0,
                  color: _selectedIndex == 1
                      ? AppColors.logocolor
                      : Colors.grey,
                ),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppImages.chaticon,
                  height: 24.0,
                  width: 24.0,
                  color: _selectedIndex == 2
                      ? AppColors.logocolor
                      : Colors.grey,
                ),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppImages.callhistoryicon,
                  height: 24.0,
                  width: 24.0,
                  color: _selectedIndex == 3
                      ? AppColors.logocolor
                      : Colors.grey,
                ),
                label: 'Call',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppImages.personicon,
                  height: 24.0,
                  width: 24.0,
                  color: _selectedIndex == 4
                      ? AppColors.logocolor
                      : Colors.grey,
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
