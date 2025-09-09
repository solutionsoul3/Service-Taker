// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'package:talk/Models/UserModel.dart';
// import 'package:talk/constants/colors.dart';
// import 'package:talk/widgets/customcontainer.dart';
//
// class CommentScreen extends StatefulWidget {
//   final String providerId;
//
//   const CommentScreen({super.key, required this.providerId});
//
//   @override
//   State<CommentScreen> createState() => _CommentScreenState();
// }
//
// class _CommentScreenState extends State<CommentScreen> {
//   final TextEditingController _commentController = TextEditingController();
//   List<Map<String, dynamic>> comments = [];
//   UserModel? currentUser;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchCurrentUser();
//     _fetchComments();
//   }
//
//   Future<void> _fetchCurrentUser() async {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId != null) {
//       DocumentSnapshot userDoc =
//           await FirebaseFirestore.instance.collection('User').doc(userId).get();
//       setState(() {
//         currentUser = UserModel.fromDocument(userDoc);
//       });
//     }
//   }
//
//   Future<void> _fetchComments() async {
//     QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection('Provider')
//         .doc(widget.providerId)
//         .collection('Reviews')
//         .orderBy('timestamp', descending: true)
//         .get();
//
//     setState(() {
//       comments = snapshot.docs.map((doc) {
//         return {
//           'name': doc['name'],
//           'message': doc['message'],
//           'imageUrl': doc['imageUrl'],
//           'timestamp': (doc['timestamp'] as Timestamp).toDate(),
//         };
//       }).toList();
//     });
//   }
//
//   Future<void> _submitComment() async {
//     if (currentUser != null && _commentController.text.isNotEmpty) {
//       await FirebaseFirestore.instance
//           .collection('Provider')
//           .doc(widget.providerId)
//           .collection('Reviews')
//           .add({
//         'name': currentUser!.name,
//         'message': _commentController.text,
//         'imageUrl': currentUser!.imageUrl,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//
//       _commentController.clear();
//       _fetchComments();
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('Please log in to comment or enter a message.')),
//       );
//     }
//   }
//
//   String _formatTimestamp(DateTime dateTime) {
//     return DateFormat('yyyy-MM-dd – hh:mm a')
//         .format(dateTime); // 12-hour format with AM/PM
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios,
//             color: Colors.white,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Center(
//           child: Text(
//             'All Reviews',
//             style: TextStyle(
//               fontSize: 22.sp,
//               color: Colors.white,
//               fontFamily: 'Urbanist',
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         backgroundColor: AppColors.logocolor,
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             height: 20.h,
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 10.w),
//             child: Text(
//               'Your voice matters!',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontFamily: 'Urbanist',
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 10.w),
//             child: Text(
//               'Great experiences deserve to be shared! Write a review and inspire others.',
//               style: TextStyle(
//                 color: Colors.grey,
//                 fontFamily: 'Urbanist',
//                 fontSize: 13.sp,
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 20.h,
//           ),
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 10.w),
//               child: ListView.builder(
//                 itemCount: comments.length,
//                 itemBuilder: (context, index) {
//                   final comment = comments[index];
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         height: 100.h,
//                         width: MediaQuery.of(context).size.width,
//                         decoration: BoxDecoration(
//                           color: const Color.fromARGB(255, 241, 239, 239),
//                           borderRadius: BorderRadius.circular(10.r),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.only(
//                             left: 10.w,
//                             right: 10.w,
//                             top: 20.h,
//                           ),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 height: 70.h,
//                                 width: 70.w,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(10),
//                                   child: comment['imageUrl'] != null
//                                       ? Image.network(
//                                           comment['imageUrl'],
//                                           fit: BoxFit.cover,
//                                         )
//                                       : Container(
//                                           color: Colors.grey, // Placeholder
//                                         ),
//                                 ),
//                               ),
//                               SizedBox(width: 10.w),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       comment['name'] ?? 'Anonymous',
//                                       style: TextStyle(
//                                         fontSize: 14.sp,
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     Text(
//                                       comment['message'] ?? '',
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                         fontSize: 13.sp,
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 5.h),
//                       Padding(
//                         padding: EdgeInsets.only(right: 10.w),
//                         child: Align(
//                           alignment: Alignment.bottomRight,
//                           child: Text(
//                             _formatTimestamp(comment['timestamp']),
//                             style: TextStyle(
//                               fontSize: 12.sp,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 15.h),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ),
//           CustomContainer(
//             height: 50.h,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _commentController,
//                     decoration: InputDecoration(
//                       hintText: 'Type your review',
//                       hintStyle: TextStyle(
//                         fontSize: 15.sp,
//                         color: Colors.grey,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'Urbanist',
//                       ),
//                       border: const OutlineInputBorder(
//                         borderSide: BorderSide.none,
//                       ),
//                       contentPadding:
//                           const EdgeInsets.symmetric(horizontal: 16.0),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(
//                     Icons.send,
//                     color: AppColors.logocolor,
//                   ),
//                   onPressed: _submitComment,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
