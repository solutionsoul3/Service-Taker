import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' hide Marker;
import 'package:talk/Models/ProviderModel.dart';
import 'package:talk/Views/ChatScreen/chattingscreenwithuser.dart';
import 'package:talk/constants/colors.dart';
import 'package:talk/constants/image.dart';
import 'package:talk/widgets/reusableboxdecoration.dart';
import 'package:url_launcher/url_launcher.dart';

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
  int selectedRating = 0; // for new selection
  int userRating = 0;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser?.uid;
    _checkIfFavorited();
    _fetchReviewCount();
    _fetchImages();
    _fetchUserRating();
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

  Future<void> _fetchUserRating() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      var doc = await FirebaseFirestore.instance
          .collection('Provider')
          .doc(widget.provider.id)
          .collection('Reviews')
          .doc(userId) // 👈 we store by uid
          .get();

      if (doc.exists) {
        setState(() {
          userRating = doc['rating'];
          selectedRating = userRating;
        });
      }
    } catch (e) {
      print("Error fetching user rating: $e");
    }
  }

  /// ✅ Save or update rating with user details
  Future<void> _saveUserRating(int rating) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // 🔹 Fetch user profile from Firestore (not only from FirebaseAuth)
      final userDoc = await FirebaseFirestore.instance
          .collection("User")
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        print("User profile not found!");
        return;
      }

      final userData = userDoc.data() ?? {};
      final userName = userData["name"] ?? "Anonymous";
      final userImage = userData["imageUrl"] ?? "";

      await FirebaseFirestore.instance
          .collection('Provider')
          .doc(widget.provider.id)
          .collection('Reviews')
          .doc(user.uid) // 👈 overwrite if exists
          .set({
        "userId": user.uid,
        "userName": userName,
        "userImage": userImage,
        "rating": rating,
        "createdAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      setState(() {
        userRating = rating;
        selectedRating = rating;
      });

      _showThankYouPopup(widget.provider.fullName);
    } catch (e) {
      print("Error saving user rating: $e");
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



  Widget _buildStarRating() {
    List<Widget> stars = [];

    for (int i = 1; i <= 5; i++) {
      stars.add(
        GestureDetector(
          onTap: () async {
            await _saveUserRating(i); // 👈 replaced inline logic
          },
          child: Icon(
            i <= selectedRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 24.h,
          ),
        ),
      );
    }

    return Row(children: stars);
  }



  void _showThankYouPopup(String providerName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🎉 Lottie Animation (download JSON from lottiefiles.com)
                Image.asset(
                  'assets/images/thankyou.gif',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 10),
                Text(
                  "Thank you!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  "You reviewed $providerName",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        );
      },
    );

    // Auto close after 2 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (Navigator.canPop(context)) Navigator.pop(context);
    });
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
                        'If you want to contact :',
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
                          // _buildIconContainer(context, Icons.message, 'Message',
                          //     widget.provider),
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

                  if (widget.provider.latitude != 0.0 && widget.provider.longitude != 0.0)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: SizedBox(
                        height: 100.h,
                        width: double.infinity,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                                widget.provider.latitude, widget.provider.longitude),
                            zoom: 14.5,
                          ),
                          markers: {
                            Marker(
                              markerId: MarkerId(widget.provider.id),
                              position: LatLng(
                                  widget.provider.latitude, widget.provider.longitude),
                              infoWindow: InfoWindow(title: widget.provider.fullName),
                            ),
                          },
                          zoomControlsEnabled: false,
                          scrollGesturesEnabled: false,
                          myLocationButtonEnabled: false,
                          tiltGesturesEnabled: false,
                        ),
                      ),
                    ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.provider.location,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Icon(Icons.location_on, color: AppColors.logocolor),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
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
              height: 50.h,
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
        // Positioned(
        //   top: 20.h,
        //   right: 16.w,
        //   child: IconButton(
        //     icon: Icon(
        //       isFavorited ? Icons.favorite : Icons.favorite_border,
        //       color: isFavorited ? Colors.red : Colors.white,
        //       size: 26.sp,
        //     ),
        //     onPressed: _toggleFavorite,
        //   ),
        // ),
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
                  _buildStarRating(),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
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

Widget _buildIconContainer(
    BuildContext context, IconData icon, String tooltip, ProviderModel provider) {
  return Container(
    width: 40.w,
    height: 40.h,
    decoration: BoxDecoration(
      color: AppColors.logocolor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: IconButton(
      onPressed: () async {
        if (icon == Icons.mail) {
          // ✅ Navigate to chat screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatWithProvider(provider: provider,),
            ),
          );
        } else if (icon == Icons.call) {
          // ✅ Fetch provider's contact number
          final String contactNumber = provider.contactNumber.isNotEmpty
              ? provider.contactNumber
              : "N/A";

          if (contactNumber == "N/A") {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("No contact number available")),
            );
            return;
          }

          final Uri callUri = Uri.parse("tel:$contactNumber");

          // ✅ Save call record in Firestore before making the call
          final currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser != null) {
            // 🔹 Fetch User Profile from Firestore (NOT FirebaseAuth)
            final userDoc = await FirebaseFirestore.instance
                .collection("User")
                .doc(currentUser.uid)
                .get();

            if (userDoc.exists) {
              final userData = userDoc.data() ?? {};

              final callerName = userData["name"] ?? "Unknown User";
              final callerImage =
                  userData["imageUrl"] ?? "https://via.placeholder.com/150";
              final callerPhoneNumber = userData["phoneNumber"] ?? "Unknown";

              await FirebaseFirestore.instance.collection("calls").add({
                "callerId": currentUser.uid,
                "callerName": callerName,
                "callerImage": callerImage,
                "callerPhoneNumber": callerPhoneNumber, // ✅ caller number

                "receiverId": provider.id,
                "receiverName": provider.fullName,
                "receiverImage": provider.imageUrl,
                "receiverContactNumber": contactNumber, // ✅ receiver number

                "participants": [currentUser.uid, provider.id],
                "timestamp": FieldValue.serverTimestamp(),
                "type": "outgoing",
              });
            }
          }

          // ✅ Launch phone dialer
          if (await canLaunchUrl(callUri)) {
            await launchUrl(callUri, mode: LaunchMode.externalApplication);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Could not launch dialer")),
            );
          }
        }
      },
      icon: Icon(icon, color: Colors.white, size: 22),
      tooltip: tooltip,
    )

  );
}



