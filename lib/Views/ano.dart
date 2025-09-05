




// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:talk/Views/ExploreCategory/explorecategory.dart';
// import 'package:talk/Views/UserScreen/userscreen.dart';
// import 'package:talk/constants/colors.dart';
// import 'package:talk/constants/image.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;

//   final List<String> _imagePaths = [
//     AppImages.banner,
//     AppImages.clean1,
//     AppImages.clean2,
//     AppImages.clean3,
//     AppImages.clean4,
//     AppImages.clean6,
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _pageController.addListener(() {
//       setState(() {
//         _currentPage = _pageController.page?.round() ?? 0;
//       });
//     });
//   }

//   void _onCardTap(String title, String imagePath, List<Color> gradientColors) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ExploreCategory(
//           title: title,
//           imagePath: imagePath,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bgcolor,
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildHeader(),
//             SizedBox(height: 20.h),
//             _buildImageCarousel(),
//             SizedBox(height: 10.h),
//             _buildPageIndicator(),
//             SizedBox(height: 10.h),
//             _buildSectionTitle('Categories', 'See all'),
//             SizedBox(height: 5.h),
//             _buildCategoryRow([
//               _CategoryData(
//                 title: 'Medical Nurse Service',
//                 imagePath: AppImages.medicalservice,
//               ),
//               _CategoryData(
//                 title: 'Motivational Speaker Service',
//                 imagePath: AppImages.moderatorservice,
//               ),
//               _CategoryData(
//                 title: 'Law Enforcement',
//                 imagePath: AppImages.lawservice,
//               ),
//             ]),
//             SizedBox(height: 10.h),
//             _buildCategoryRow([
//               _CategoryData(
//                 title: 'Car Driver Service',
//                 imagePath: AppImages.textservice,
//               ),
//               _CategoryData(
//                 title: 'Home Teacher Service',
//                 imagePath: AppImages.womanservice,
//               ),
//               _CategoryData(
//                 title: 'Car Wash Service',
//                 imagePath: AppImages.carwashservice,
//               ),
//             ]),
//             SizedBox(height: 10.h),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 10.w),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Home Services',
//                     style: TextStyle(
//                       fontSize: 18.sp,
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Urbanist',
//                     ),
//                   ),
//                   Text(
//                     'See all',
//                     style: TextStyle(
//                       fontSize: 15.sp,
//                       fontFamily: 'Urbanist',
//                       color: AppColors.logocolor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 5.h),
//             SizedBox(
//               height: 200.h,
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 10.w),
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: 5,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: EdgeInsets.all(5.r),
//                       child: GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const UserScreen()),
//                           );
//                         },
//                         child: Container(
//                           width: 200.w,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10.r),
//                             color: Colors.white,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black12,
//                                 blurRadius: 4.r,
//                                 offset: const Offset(
//                                     0, 4), // Adjust shadow position
//                               ),
//                             ],
//                           ),
//                           child: GestureDetector(
//                             onTap: () => {},
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(10.r),
//                                   child: Image.asset(
//                                     AppImages.service1,
//                                     fit: BoxFit.cover,
//                                     height: 100.h,
//                                     width: double.infinity,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.all(8.w),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Dish Washer',
//                                         style: TextStyle(
//                                           fontSize: 13.sp,
//                                           color: Colors.grey,
//                                           fontFamily: 'Urbanist',
//                                         ),
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             'Starts From ',
//                                             style: TextStyle(
//                                               fontSize: 14.sp,
//                                               color: Colors.black,
//                                               fontWeight: FontWeight.bold,
//                                               fontFamily: 'Urbanist',
//                                             ),
//                                           ),
//                                           Text(
//                                             'Rs 200',
//                                             style: TextStyle(
//                                               fontSize: 14.sp,
//                                               color: AppColors.logocolor,
//                                               fontFamily: 'Urbanist',
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Image.asset(
//                                         AppImages.star,
//                                         fit: BoxFit.cover,
//                                         height: 20.h,
//                                         width: 100.w,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//             SizedBox(height: 10.h),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 10.w),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Car Wash Services',
//                     style: TextStyle(
//                       fontSize: 18.sp,
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Urbanist',
//                     ),
//                   ),
//                   Text(
//                     'See all',
//                     style: TextStyle(
//                       fontSize: 15.sp,
//                       color: AppColors.logocolor,
//                       fontFamily: 'Urbanist',
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 5.h),
//             SizedBox(
//               height: 200.h,
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 10.w),
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: 5,
//                   itemBuilder: (context, index) {
//                     return GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const UserScreen()),
//                         );
//                       },
//                       child: Padding(
//                         padding: EdgeInsets.all(5.r),
//                         child: Container(
//                           width: 200.w, // Adjust the width as needed
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10.r),
//                             color: Colors.white,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black12,
//                                 blurRadius: 4.r,
//                                 offset: const Offset(
//                                     0, 4), // Adjust shadow position
//                               ),
//                             ],
//                           ),
//                           child: GestureDetector(
//                             onTap: () => {},
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(10.r),
//                                   child: Image.asset(
//                                     AppImages.service2,
//                                     fit: BoxFit.cover,
//                                     height: 100.h,
//                                     width: double.infinity,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.all(8.w),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Car Wash',
//                                         style: TextStyle(
//                                           fontSize: 13.sp,
//                                           color: Colors.grey,
//                                           fontFamily: 'Urbanist',
//                                         ),
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             'Starts From ',
//                                             style: TextStyle(
//                                               fontSize: 14.sp,
//                                               color: Colors.black,
//                                               fontFamily: 'Urbanist',
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                           Text(
//                                             'Rs 100',
//                                             style: TextStyle(
//                                               fontSize: 14.sp,
//                                               color: AppColors.logocolor,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Image.asset(
//                                         AppImages.star,
//                                         fit: BoxFit.cover,
//                                         height: 20.h,
//                                         width: 100.w,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//             SizedBox(height: 10.h),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 10.w),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Nurse Services',
//                     style: TextStyle(
//                       fontSize: 18.sp,
//                       color: Colors.black,
//                       fontFamily: 'Urbanist',
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     'See all',
//                     style: TextStyle(
//                       fontSize: 15.sp,
//                       fontFamily: 'Urbanist',
//                       color: AppColors.logocolor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 5.h),
//             SizedBox(
//               height: 200.h,
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 10.w),
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: 5,
//                   itemBuilder: (context, index) {
//                     return GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const UserScreen()),
//                         );
//                       },
//                       child: Padding(
//                         padding: EdgeInsets.all(5.r),
//                         child: Container(
//                           width: 200.w,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10.r),
//                             color: Colors.white,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black12,
//                                 blurRadius: 4.r,
//                                 offset: const Offset(0, 4),
//                               ),
//                             ],
//                           ),
//                           child: GestureDetector(
//                             onTap: () => {},
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(10.r),
//                                   child: Image.asset(
//                                     AppImages.service3,
//                                     fit: BoxFit.cover,
//                                     height: 100.h,
//                                     width: double.infinity,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.all(8.w),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Nurse',
//                                         style: TextStyle(
//                                           fontSize: 13.sp,
//                                           color: Colors.grey,
//                                           fontFamily: 'Urbanist',
//                                         ),
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             'Starts From ',
//                                             style: TextStyle(
//                                               fontSize: 14.sp,
//                                               color: Colors.black,
//                                               fontFamily: 'Urbanist',
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                           Text(
//                                             'Rs 500',
//                                             style: TextStyle(
//                                               fontSize: 14.sp,
//                                               fontFamily: 'Urbanist',
//                                               color: AppColors.logocolor,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Image.asset(
//                                         AppImages.star,
//                                         fit: BoxFit.cover,
//                                         height: 20.h,
//                                         width: 100.w,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       height: 250.h,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(20.r),
//           bottomRight: Radius.circular(20.r),
//         ),
//         gradient: const LinearGradient(
//           colors: [AppColors.logocolor, AppColors.logocolor],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             height: 30.h,
//           ),
//           IconButton(
//             icon: const Icon(
//               Icons.menu,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               // Implement menu action here
//             },
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: 15.w,
//             ),
//             child: Text(
//               'Welcome',
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 color: Colors.white,
//                 fontFamily: 'Urbanist',
//               ),
//             ),
//           ),
//           SizedBox(height: 10.h),
//           Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: 15.w,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Ali Abbas',
//                   style: TextStyle(
//                     fontSize: 19.sp,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Urbanist',
//                   ),
//                 ),
//                 const Icon(Icons.notifications, color: Colors.white),
//               ],
//             ),
//           ),
//           SizedBox(height: 10.h),
//           Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: 15.w,
//             ),
//             child: Row(
//               children: [
//                 const Icon(Icons.location_on, color: Colors.white),
//                 SizedBox(width: 8.w),
//                 Text(
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w500,
//                   'Lahore, Pakistan',
//                     color: Colors.white,
//                     fontFamily: 'Urbanist',
//                   ),
//                 ),
//                 SizedBox(width: 8.w),
//                 const Icon(Icons.arrow_drop_down, color: Colors.white),
//               ],
//             ),
//           ),
//           SizedBox(height: 20.h),
//           Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: 15.w,
//             ),
//             child: _buildSearchBar(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Container(
//       height: 50.h,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10.r),
//         border: Border.all(color: Colors.white, width: 1),
//         color: Colors.white,
//       ),
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.w),
//         child: Row(
//           children: [
//             const Icon(Icons.search, color: AppColors.logocolor),
//             SizedBox(width: 8.w),
//             Expanded(
//               child: TextField(
//                 decoration: InputDecoration(
//                   hintText: 'Search...',
//                   hintStyle: TextStyle(
//                     fontSize: 14.sp,
//                     color: Colors.grey,
//                     fontFamily: 'Urbanist',
//                   ),
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//             const Icon(Icons.filter_list, color: AppColors.logocolor),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildImageCarousel() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 10.w),
//       child: Container(
//         height: 150.h,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10.r),
//           color: Colors.white,
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(10.r),
//           child: PageView.builder(
//             controller: _pageController,
//             itemCount: _imagePaths.length,
//             itemBuilder: (context, index) => Image.asset(
//               _imagePaths[index],
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPageIndicator() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(
//         _imagePaths.length,
//         (index) => Container(
//           margin: EdgeInsets.symmetric(horizontal: 4.w),
//           width: 8.w,
//           height: 8.h,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: _currentPage == index ? AppColors.logocolor : Colors.grey,
//           ),
//         ),
//       ),
//     );
//   }
//   Widget _buildSectionTitle(String title, String action) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 10.w),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 18.sp,
//               color: Colors.black,
//               fontWeight: FontWeight.bold,
//               fontFamily: 'Urbanist',
//             ),
//           ),
//           Text(
//             action,
//             style: TextStyle(
//               fontSize: 15.sp,
//               color: AppColors.logocolor,
//               fontFamily: 'Urbanist',
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCategoryRow(List<_CategoryData> categories) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 25.w),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children:
//             categories.map((category) => _buildCategoryCard(category)).toList(),
//       ),
//     );
//   }

//   Widget _buildCategoryCard(_CategoryData data) {
//     return GestureDetector(
//       onTap: () => _onCardTap(
//           data.title, data.imagePath, [AppColors.bgcolor, AppColors.bgcolor]),
//       child: Container(
//         height: 110.h,
//         width: 100.w,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10.r),
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 4.r,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: EdgeInsets.only(top: 5.h, left: 5.w, right: 3.w),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 data.title,
//                 style: TextStyle(
//                   fontSize: 12.sp,
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Urbanist',
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 8.h),
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(10.r),
//                 child: Image.asset(
//                   data.imagePath,
//                   fit: BoxFit.cover,
//                   height: 30.h,
//                   width: 30.w,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _CategoryData {
//   final String title;
//   final String imagePath;

//   _CategoryData({required this.title, required this.imagePath});
// }
