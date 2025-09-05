// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:talk/Views/ProviderDetails/providerdetails.dart';
// import 'package:talk/constants/colors.dart';
// import 'package:talk/widgets/reusableboxdecoration.dart';

// // Define the data model for the providers
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

// class PremiumTab extends StatelessWidget {
//   const PremiumTab({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 10.w),
//         child: ListView.builder(
//           itemCount: providers.length,
//           itemBuilder: (context, index) {
//             final provider = providers[index];
//             return Column(
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>  ProviderDetailsScreen(
//                           image: provider.image,
//                           name: provider.name,
//                           price: provider.price,
//                           post: provider.post,
//                         ),
//                       ),
//                     );
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: ReusableBoxDecoration(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 provider.name,
//                                 style: reusableTextStyle(
//                                   fontSize: 16.sp,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 provider.price,
//                                 style: reusableTextStyle(
//                                   fontSize: 14.sp,
//                                   color: AppColors.logocolor,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const Divider(),
//                           Row(
//                             children: [
//                               Container(
//                                 height: 80.h,
//                                 width: 100.w,
//                                 decoration: BoxDecoration(
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black12,
//                                       blurRadius: 4.r,
//                                       offset: const Offset(0, 4),
//                                     ),
//                                   ],
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(16),
//                                   child: Image.asset(
//                                     provider.image,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 10.w),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       provider.post,
//                                       textAlign: TextAlign.center,
//                                       style: reusableTextStyle(
//                                         fontSize: 14.sp,
//                                         color: AppColors.logocolor,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     Text(
//                                       'Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,',
//                                       style: reusableTextStyle(
//                                         fontSize: 11.sp,
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10.h), // Spacing between items
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// TextStyle reusableTextStyle({
//   double fontSize = 14.0,
//   FontWeight fontWeight = FontWeight.normal,
//   Color color = Colors.black,
//   String fontFamily = 'Urbanist',
// }) {
//   return TextStyle(
//     fontSize: fontSize,
//     fontWeight: fontWeight,
//     color: color,
//     fontFamily: fontFamily,
//   );
// }
