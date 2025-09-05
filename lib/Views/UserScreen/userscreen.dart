// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:talk/Views/ProviderDetails/providerdetails.dart';
// import 'package:talk/constants/colors.dart';
// import 'package:talk/constants/image.dart';
// import 'package:talk/widgets/reusableboxdecoration.dart';

// class Provider {
//   final String image;
//   final String name;
//   final String price;
//   final String post;

//   Provider({
//     required this.image,
//     required this.name,
//     required this.price,
//     required this.post,
//   });
// }

// // List of providers
// final List<Provider> providers = [
//   Provider(
//     image: 'assets/images/homepics/user1.jpg',
//     name: 'Jinny',
//     price: '\$300/hr',
//     post: 'Nurse',
//   ),
//   Provider(
//     image: 'assets/images/homepics/user2.jpg',
//     name: 'Emily',
//     price: '\$400/hr',
//     post: 'Nurse',
//   ),
//   Provider(
//     image: 'assets/images/homepics/user3.jpg',
//     name: 'John',
//     price: '\$250/hr',
//     post: 'Nurse',
//   ),
//   Provider(
//     image: 'assets/images/homepics/user4.jpg',
//     name: 'Sophia',
//     price: '\$700/hr',
//     post: 'Nurse',
//   ),
//   Provider(
//     image: 'assets/images/homepics/user5.jpg',
//     name: 'Michael',
//     price: '\$505/hr',
//     post: 'Nurse',
//   ),
// ];

// class UserScreen extends StatelessWidget {
//   const UserScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bgcolor,
//       body: SingleChildScrollView(
//         child: Stack(
//           children: [
//             _buildBackgroundContainer(context),
//             _buildHeaderImage(context),
//             _buildServiceCard(context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBackgroundContainer(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(top: 250.h),
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 20.h),
//             Row(
//               children: [
//                 _buildServiceButton('Decoration Services'),
//                 SizedBox(width: 10.w),
//                 _buildServiceButton('Creativity Services'),
//               ],
//             ),
//             SizedBox(height: 10.h),
//             _buildServiceButton('Sewer Cleaning'),
//             SizedBox(height: 10.h),
//             ReusableBoxDecoration(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Description',
//                     style: reusableTextStyle(
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const Divider(),
//                   Text(
//                     'Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type',
//                     style: reusableTextStyle(
//                       fontSize: 13.sp,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10.h),
//             ReusableBoxDecoration(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Duration',
//                     style: reusableTextStyle(
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'This Service can take up to :',
//                         style: reusableTextStyle(
//                           fontSize: 13.sp,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       Text(
//                         '1 hour',
//                         style: reusableTextStyle(
//                           fontSize: 15.sp,
//                           color: AppColors.logocolor,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 800.h,
//               child: ListView.builder(
//                 itemCount: providers.length,
//                 itemBuilder: (context, index) {
//                   final provider = providers[index];
//                   return Column(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   const ProviderDetailsScreen(),
//                             ),
//                           );
//                         },
//                         child: ReusableBoxDecoration(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     provider.name,
//                                     style: reusableTextStyle(
//                                       fontSize: 16.sp,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   const Spacer(),
//                                   Text(
//                                     provider.price,
//                                     style: reusableTextStyle(
//                                       fontSize: 14.sp,
//                                       color: AppColors.logocolor,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 10.w,
//                                   ),
//                                   Image.asset(
//                                     AppImages.star,
//                                     fit: BoxFit.cover,
//                                     height: 20.h,
//                                     width: 100.w,
//                                   ),
//                                 ],
//                               ),
//                               const Divider(),
//                               Row(
//                                 children: [
//                                   Container(
//                                     height: 80.h,
//                                     width: 100.w,
//                                     decoration: BoxDecoration(
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.black12,
//                                           blurRadius: 4.r,
//                                           offset: const Offset(0, 4),
//                                         ),
//                                       ],
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(16),
//                                       child: Image.asset(
//                                         provider.image,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(width: 10.w),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           provider.post,
//                                           textAlign: TextAlign.center,
//                                           style: reusableTextStyle(
//                                             fontSize: 14.sp,
//                                             color: AppColors.logocolor,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         Text(
//                                           'Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,',
//                                           style: reusableTextStyle(
//                                             fontSize: 11.sp,
//                                             color: Colors.grey,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 10.h), // Spacing between items
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildServiceButton(String text) {
//     return Container(
//       height: 30.h,
//       width: 150.w,
//       decoration: BoxDecoration(
//         color: AppColors.logocolor,
//         borderRadius: BorderRadius.circular(20.r),
//       ),
//       child: Center(
//         child: Text(
//           text,
//           style: reusableTextStyle(
//             fontSize: 13.sp,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeaderImage(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           height: 200.h,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [Colors.black, AppColors.logocolor],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(20.r),
//               bottomRight: Radius.circular(20.r),
//             ),
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(15.r),
//               bottomRight: Radius.circular(10.r),
//             ),
//             child: ColorFiltered(
//               colorFilter: ColorFilter.mode(
//                 Colors.black.withOpacity(0.3), // Adjust opacity as needed
//                 BlendMode.darken, // Use the appropriate blend mode
//               ),
//               child: Image.asset(
//                 'assets/images/decoration1.jpg',
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         ),
//         Positioned(
//           top: 16.h, // Adjust this value as needed
//           left: 16.w, // Adjust this value as needed
//           child: IconButton(
//             icon: Icon(
//               Icons.arrow_back_ios,
//               color: Colors.white,
//               size: 24.sp, // Adjust the size as needed
//             ),
//             onPressed: () {
//               Navigator.of(context)
//                   .pop(); // Navigate back to the previous screen
//             },
//           ),
//         ),
//         Positioned(
//           top: 16.h, // Adjust this value as needed
//           right: 16.w, // Adjust this value as needed
//           child: IconButton(
//             icon: Icon(
//               Icons.favorite,
//               color: Colors.red,
//               size: 24.sp,
//             ),
//             onPressed: () {},
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildServiceCard(BuildContext context) {
//     return Positioned(
//       top: 150.h,
//       left: 30.w,
//       right: 30.w,
//       child: Container(
//         height: 110.h,
//         width: MediaQuery.of(context).size.width,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10.r),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 4.r,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Home Style Services',
//                     style: TextStyle(
//                       fontSize: 16.sp,
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Urbanist',
//                     ),
//                   ),
//                   Container(
//                     height: 25.h,
//                     width: 80.w,
//                     decoration: BoxDecoration(
//                       color: const Color.fromARGB(255, 209, 208, 208),
//                       borderRadius: BorderRadius.circular(10.r),
//                     ),
//                     child: Center(
//                       child: Text(
//                         'Online',
//                         style: TextStyle(
//                           fontSize: 13.sp,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                           fontFamily: 'Urbanist',
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10.h),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Reviews(6)',
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       color: Colors.grey,
//                       fontFamily: 'Urbanist',
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 5.h),
//                   Text(
//                     '\$200',
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       color: AppColors.logocolor,
//                       fontFamily: 'Urbanist',
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10.h),
//               Text(
//                 'Total Providers we have (10)',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   color: Colors.grey,
//                   fontFamily: 'Urbanist',
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
