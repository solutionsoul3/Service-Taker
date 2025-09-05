import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/Models/ProviderModel.dart';
import 'package:talk/Views/BookService/bookservice.dart';
import 'package:talk/Views/ChatScreen/chattingscreenwithuser.dart';
import 'package:talk/Views/ReviewScreen/review_screen.dart';
import 'package:talk/Views/auth/HelpScreen/ImageViewerScreen.dart';
import 'package:talk/constants/colors.dart';
import 'package:talk/constants/image.dart';
import 'package:talk/constants/reusable_button.dart';
import 'package:talk/widgets/reusableboxdecoration.dart';

class ProviderDetailsScreen extends StatefulWidget {
  final ProviderModel provider;
  const ProviderDetailsScreen({super.key, required this.provider});
  @override
  State<ProviderDetailsScreen> createState() => _ProviderDetailsScreenState();
}

class _ProviderDetailsScreenState extends State<ProviderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            _buildBackgroundContainer(context),
            _buildHeaderImage(context),
            _buildServiceCard(context),
          ],
        ),
      ),
    );
  }

  bool isFavorited = false;
  String? currentUserId;
  int reviewCount = 0;
  List<String> imageUrls = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser?.uid;
    _checkIfFavorited();
    _fetchReviewCount();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    try {
      final portfolioDocRef = FirebaseFirestore.instance
          .collection('Provider')
          .doc(widget.provider.uid)
          .collection('Portfolio')
          .doc('myrecord');

      final docSnapshot = await portfolioDocRef.get();

      if (docSnapshot.exists) {
        setState(() {
          imageUrls = List<String>.from(docSnapshot.data()?['images'] ?? []);
          _isLoading = false; // Data fetched successfully
        });
      } else {
        setState(() {
          _error = 'Provider have not uploaded any data yet.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error fetching images: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchReviewCount() async {
    try {
      // Reference to the Reviews collection of the specific provider
      var reviewsSnapshot = await FirebaseFirestore.instance
          .collection('Provider')
          .doc(widget.provider.id)
          .collection('Reviews')
          .get();

      // Update the review count with the number of documents
      setState(() {
        reviewCount = reviewsSnapshot.docs.length;
      });
    } catch (e) {
      print('Error fetching review count: $e');
    }
  }

  Widget _buildStarRating(int count) {
    double rating;

    if (count > 10) {
      rating = 4.0; // 4 stars
    } else if (count >= 5) {
      rating = 3.5; // 3.5 stars
    } else if (count >= 3) {
      rating = 3.0; // 3 stars
    } else {
      rating = 0.0; // No stars
    }

    List<Widget> stars = [];

    for (int i = 0; i < 5; i++) {
      if (i < rating) {
        stars.add(
          Icon(
            Icons.star,
            color: Colors.amber,
            size: 20.h, // Adjust size as needed
          ),
        );
      } else {
        stars.add(
          Icon(
            Icons.star_border,
            color: Colors.amber,
            size: 20.h, // Adjust size as needed
          ),
        );
      }
    }

    return Row(
      children: stars,
    );
  }

  String _getRatingValue(int reviewCount) {
    if (reviewCount > 10) {
      return '4';
    } else if (reviewCount >= 5) {
      return '3.5';
    } else if (reviewCount >= 3) {
      return '3';
    }
    return '0';
  }

  void _checkIfFavorited() async {
    if (currentUserId != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('User').doc(currentUserId);
      final favoritesSnapshot = await userDoc
          .collection('Myfav')
          .where('providerId', isEqualTo: widget.provider.id)
          .get();

      setState(() {
        isFavorited = favoritesSnapshot.docs.isNotEmpty;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    if (currentUserId != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('User').doc(currentUserId);

      if (isFavorited) {
        // Remove from favorites
        await userDoc.collection('Myfav').doc(widget.provider.id).delete();
        setState(() {
          isFavorited = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Removed from favorites!',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Urbanist',
              ),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      } else {
        // Add to favorites
        String ratingValue = _getRatingValue(reviewCount);
        await userDoc.collection('Myfav').doc(widget.provider.id).set({
          'providerId': widget.provider.id,
          'price': widget.provider.pricePerHour,
          'providerName': widget.provider.fullName,
          'imageUrl': widget.provider.imageUrl,
          'description': widget.provider.description,
          'email': widget.provider.email,
          'experience': widget.provider.experience,
          'experience Description': widget.provider.experienceDescription,
          'service': widget.provider.service,
          'contact Number': widget.provider.contactNumber,
          'location': widget.provider.location,
          'rating': ratingValue,

          // Add other relevant fields if necessary
        });
        setState(() {
          isFavorited = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Added to favorites!',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Urbanist',
              ),
            ),
            backgroundColor: Colors.lightGreen,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in!')),
      );
    }
  }

  Widget _buildBackgroundContainer(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 250.h),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReusableBoxDecoration(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact',
                    style: reusableTextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'If you have any question :',
                        style: reusableTextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildIconContainer(
                              context, Icons.mail, 'mail', widget.provider),
                          SizedBox(
                            width: 5.w,
                          ),
                          _buildIconContainer(
                              context, Icons.call, 'Call', widget.provider),
                          SizedBox(
                            width: 5.w,
                          ),
                          _buildIconContainer(context, Icons.message, 'Message',
                              widget.provider),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              width: 400.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.asset(
                      AppImages.map,
                      fit: BoxFit.cover,
                      height: 150.h,
                      width: double.infinity,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.provider.location,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(Icons.location_on,
                            color: AppColors.logocolor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            ReusableBoxDecoration(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: reusableTextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  Text(
                    widget.provider.experienceDescription,
                    style: reusableTextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            ReusableBoxDecoration(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Availability',
                    style: reusableTextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  Column(
                    children: widget.provider.availability.map((availability) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            availability.day,
                            style: reusableTextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            '${availability.startTime} - ${availability.endTime}',
                            style: reusableTextStyle(
                              fontSize: 14.sp,
                              color: AppColors.logocolor,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            ReusableBoxDecoration(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Experience',
                        style: reusableTextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.provider.experience} year',
                        style: reusableTextStyle(
                          fontSize: 14.sp,
                          color: AppColors.logocolor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Text(
                    widget.provider.experienceDescription,
                    style: reusableTextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            ReusableBoxDecoration(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Portfolio Details',
                        style: reusableTextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigate to ImageViewerScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageViewerScreen(
                                imageUrls: imageUrls,
                                initialIndex:
                                    0, // or whichever index you want to start with
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'View All',
                          style: reusableTextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.logocolor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  SizedBox(
                    height: 200.h,
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _error != null
                            ? Center(child: Text(_error!))
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: imageUrls.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.all(10.r),
                                    child: Container(
                                      width: 200.w,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4.r,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: GestureDetector(
                                        onTap: () => {},
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              child: Image.network(
                                                imageUrls[index],
                                                fit: BoxFit.cover,
                                                height: 150.h,
                                                width: double.infinity,
                                              ),
                                            ),
                                            Image.asset(
                                              AppImages.star,
                                              height: 20.h,
                                              width: 100.w,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            CustomElevatedButton(
              text: 'Book Service ',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          BookServiceScreen(provider: widget.provider)),
                );
              },
              height: 40.h,
              width: 400.w,
              backgroundColor: AppColors.logocolor,
              textColor: Colors.white,
              borderRadius: 10.r,
            ),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200.h,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.black, AppColors.logocolor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.r),
              bottomRight: Radius.circular(20.r),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.r),
              bottomRight: Radius.circular(20.r),
            ),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken,
              ),
              child: Image.network(
                widget.provider.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          top: 20.h,
          left: 16.w,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 24.sp,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        Positioned(
          top: 20.h,
          right: 16.w,
          child: IconButton(
            icon: Icon(
              isFavorited ? Icons.favorite : Icons.favorite_border,
              color: isFavorited ? Colors.red : Colors.white,
              size: 26.sp,
            ),
            onPressed: _toggleFavorite,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(BuildContext context) {
    return Positioned(
      top: 150.h,
      left: 30.w,
      right: 30.w,
      child: Container(
        height: 90.h,
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.provider.fullName.isNotEmpty
                        ? widget.provider.fullName
                        : 'N/A',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                  Container(
                    height: 35.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 209, 208, 208),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                      child: Text(
                        _getRatingValue(reviewCount),
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStarRating(reviewCount),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CommentScreen(providerId: widget.provider.id),
                        ),
                      );
                    },
                    child: Text(
                      'Reviews($reviewCount)',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '\$${widget.provider.pricePerHour.toString()}',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: AppColors.logocolor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildIconContainer(BuildContext context, IconData icon, String tooltip,
    ProviderModel provider) {
  return Container(
    width: 40.w,
    height: 40.h,
    decoration: BoxDecoration(
      color: AppColors.logocolor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: IconButton(
      onPressed: () {
        // Navigate to chat screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatWithUser(
              provider: provider, // Pass the whole provider object
            ),
          ),
        );
      },
      icon: Icon(
        icon,
        color: Colors.white,
        size: 22,
      ),
      tooltip: tooltip,
    ),
  );
}
