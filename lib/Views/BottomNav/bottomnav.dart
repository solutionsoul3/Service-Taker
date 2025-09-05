import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:talk/Views/ChatScreen/chatscreen.dart';
import 'package:talk/Views/FavScreen/favscreen.dart';
import 'package:talk/Views/HomeScreen/homescreen.dart';
import 'package:talk/Views/MyBookings/mybookings.dart';
import 'package:talk/Views/ProfileScreen/aboutscreen.dart';
import 'package:talk/constants/colors.dart';
import 'package:talk/constants/image.dart';

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
    const MyBookingScreen(),
    const FavScreen(),
    WhatsAppStyleScreen(),
    const MyBookingScreen(),
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
              color: Colors.black.withOpacity(0.1), // Shadow color
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, -2), // Adjust position of the shadow
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
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppImages.homeicon,
                  color:
                      _selectedIndex == 0 ? AppColors.logocolor : Colors.grey,
                  height: 24.0,
                  width: 24.0,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppImages.bookingicon,
                  color:
                      _selectedIndex == 1 ? AppColors.logocolor : Colors.grey,
                  height: 24.0,
                  width: 24.0,
                ),
                label: 'Bookings',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppImages.favicon,
                  color:
                      _selectedIndex == 2 ? AppColors.logocolor : Colors.grey,
                  height: 24.0,
                  width: 24.0,
                ),
                label: 'Favorite',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppImages.chaticon,
                  color:
                      _selectedIndex == 3 ? AppColors.logocolor : Colors.grey,
                  height: 24.0,
                  width: 24.0,
                ),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppImages.callhistoryicon,
                  color:
                      _selectedIndex == 4 ? AppColors.logocolor : Colors.grey,
                  height: 24.0,
                  width: 24.0,
                ),
                label: 'Calls',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppImages.personicon,
                  color:
                      _selectedIndex == 5 ? AppColors.logocolor : Colors.grey,
                  height: 24.0,
                  width: 24.0,
                ),
                label: 'Profile',
              ),
            ],
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}
