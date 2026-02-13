import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/Views/ExploreCategory/explorecategory.dart';

class PopularServiceCard extends StatelessWidget {
  final Map<String, dynamic> category;

  const PopularServiceCard({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = category['catename'] ?? '';
    final imagePath = category['imageURL'] ?? '';
    final rating = (category['rating'] is num) ? category['rating'].toDouble() : 4.8;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ExploreCategory(
              category: category,
              categoryName: name,
            ),
          ),
        );
      },
      child: Container(
        width: 160.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _imageSection(imagePath, rating),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Urbanist",
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14.sp, color: Colors.grey[600]),
                      SizedBox(width: 4.w),
                      Text("30-60 mins",
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
                      const Spacer(),
                      Icon(Icons.thumb_up, size: 14.sp, color: Colors.grey[600]),
                      SizedBox(width: 4.w),
                      Text("98%", style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageSection(String imagePath, double rating) {
    return Stack(
      children: [
        Container(
          height: 120.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
            color: Colors.grey[100],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
            child: imagePath.isNotEmpty
                ? Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(Icons.image_not_supported,
                      color: Colors.grey[400], size: 28.sp),

                );
              },
            )
                : Container(
              color: Colors.grey[300],
              child: Icon(Icons.image, color: Colors.grey[400], size: 40.sp),
            ),
          ),
        ),
        Container(
          height: 120.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.1)],
            ),
          ),
        ),
        // Positioned(
        //   bottom: 10.h,
        //   left: 10.w,
        //   child: _ratingBadge(rating),
        // ),
      ],
    );
  }
  //
  // Widget _ratingBadge(double rating) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12.r),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 4,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Icon(Icons.star, color: Colors.amber, size: 14.sp),
  //         SizedBox(width: 4.w),
  //         Text(
  //           rating.toString(),
  //           style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Colors.black87),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
