import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/Constants/colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Sample data lists
  final List<String> images = [
    'assets/images/homepics/user1.jpg',
    'assets/images/homepics/user2.jpg',
    'assets/images/homepics/user3.jpg',
    'assets/images/homepics/user4.jpg',
    'assets/images/homepics/user5.jpg',
  ];

  final List<String> messages = [
    '#1 New booking has been submitted',
    '#2 New booking has been submitted',
    '#3 New booking has been submitted',
    '#4 New booking has been submitted',
    '#5 New booking has been submitted',
  ];

  final List<String> timestamps = [
    '20, Feb 2024 | 3:00 PM',
    '21, Feb 2024 | 4:00 PM',
    '22, Feb 2024 | 5:00 PM',
    '23, Feb 2024 | 6:00 PM',
    '24, Feb 2024 | 7:00 PM',
    '25, Feb 2024 | 8:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      appBar: AppBar(
        backgroundColor: AppColors.logocolor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Text(
            'Notifications',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () {
              // Add functionality for bell icon here
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.h,
            ),
            Text(
              'Incoming Notification',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Urbanist',
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Swipe items left to delete.',
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'Urbanist',
                fontSize: 13.sp,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(messages[index]), // Unique key for each item
                    direction: DismissDirection.endToStart, // Swipe direction
                    background: Container(
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                        color: AppColors.logocolor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (direction) {
                      // Remove the item from the data source
                      setState(() {
                        images.removeAt(index);
                        messages.removeAt(index);
                        timestamps.removeAt(index);
                      });

                      // Show a snackbar after deleting
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.lightGreen,
                          content: Text(
                            'Notification deleted',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 100.h,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 241, 239, 239),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 10.w,
                              right: 10.w,
                              top: 20.h,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 70.h,
                                  width: 70.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      images[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        messages[index],
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        timestamps[index],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
