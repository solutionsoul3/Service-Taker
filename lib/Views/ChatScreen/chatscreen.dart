import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/constants/colors.dart';

class WhatsAppStyleScreen extends StatelessWidget {
  final List<Map<String, String>> users = [
    {
      'name': 'John Doe',
      'image': 'assets/images/person4.jpg',
    },
    {
      'name': 'Jane Smith',
      'image': 'assets/images/person3.jpg',
    },
    {
      'name': 'Alice Johnson',
      'image': 'assets/images/person1.jpg',
    },
    {
      'name': 'Iqra',
      'image': 'assets/images/dishwasher.png',
    },
    {
      'name': 'Fardeen',
      'image': 'assets/images/services1.jpg',
    },
    {
      'name': 'Ali',
      'image': 'assets/images/services2.jpg',
    },
    {
      'name': 'Talha',
      'image': 'assets/images/banner.jpg',
    },
    {
      'name': 'Shahmeer',
      'image': 'assets/images/clean6.jpeg',
    },
    {
      'name': 'Shaitan',
      'image': 'assets/images/app_logo.jpeg',
    },
  ];

  WhatsAppStyleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Chats',
            style: TextStyle(
              fontSize: 22.sp,
              color: Colors.white,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: AppColors.logocolor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Container(
              height: 50.h,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                  border: InputBorder.none,
                  hintText: 'Search...',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Urbanist',
                    fontSize: 14.sp,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  suffixIcon: const Icon(
                    Icons.filter_list,
                    color: Colors.grey,
                  ),
                ),
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const ChatWithUser(),
                        //   ),
                        // );
                      },
                      child: Column(
                        children: [
                          ReusableBoxDecoration(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 50.h,
                                      width: 50.w,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4.r,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          user['image']!,
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
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                user['name']!,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: AppColors.logocolor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                '10:00',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: AppColors.logocolor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'message',
                                                style: TextStyle(
                                                  fontSize: 11.sp,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                '9/6/2023',
                                                style: TextStyle(
                                                  fontSize: 11.sp,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(height: 10.h), // Add spacing between items
                        ],
                      ),
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

class ReusableBoxDecoration extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const ReusableBoxDecoration({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0), // Adjust as per your needs
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 2.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
