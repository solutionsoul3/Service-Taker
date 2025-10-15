import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Constants/colors.dart';
import '../../Controller/provider-controller.dart';
import '../../Models/ProviderModel.dart';
import '../ProviderDetails/providerdetails.dart';
import 'dart:math' show cos, sqrt, asin, pi, sin;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ExploreCategory extends StatefulWidget {
  final dynamic category; // full category object
  final String categoryName; // just the name like "Plumber"

  const ExploreCategory({
    super.key,
    required this.category,
    required this.categoryName,
  });

  @override
  State<ExploreCategory> createState() => _ExploreCategoryState();
}

class _ExploreCategoryState extends State<ExploreCategory>
    with SingleTickerProviderStateMixin {
  final ProviderController controller = Get.put(ProviderController());
  List<ProviderModel> nearestProviders = [];
  double _scaleFactor = 1.0;
  double? userLat;
  double? userLng;
  String _currentLocation = "Fetching location...";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNearestProviders();
    _getUserLocation();
  }

  Future<void> _loadNearestProviders() async {
    try {
      setState(() => _isLoading = true); // ✅ Start loading
      // ✅ Request location permission
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) return;

      // ✅ Get current user position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      userLat = position.latitude;
      userLng = position.longitude;

      // ✅ Fetch all providers in this category
      await controller.fetchProvidersByCategory(widget.categoryName);

      // ✅ Filter providers that have valid coordinates
      List<ProviderModel> validProviders = controller.providers.where((p) {
        return p.latitude != 0.0 && p.longitude != 0.0;
      }).toList();

      // ✅ Calculate distance and keep only those within 20 km
      List<ProviderModel> nearby = validProviders.where((p) {
        double distance =
            calculateDistance(userLat!, userLng!, p.latitude, p.longitude);
        return distance <= 20.0; // ✅ only providers within 20 km
      }).toList();

      // ✅ Sort nearby providers by distance (nearest first)
      nearby.sort((a, b) {
        double distanceA =
            calculateDistance(userLat!, userLng!, a.latitude, a.longitude);
        double distanceB =
            calculateDistance(userLat!, userLng!, b.latitude, b.longitude);
        return distanceA.compareTo(distanceB);
      });

      setState(() {
        nearestProviders = nearby;
      });
    } catch (e) {
      print("❌ Error loading nearest providers: $e");
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Earth's radius in km
    double dLat = (lat2 - lat1) * pi / 180;
    double dLon = (lon2 - lon1) * pi / 180;
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * asin(sqrt(a));
    return R * c;
  }

  void sortProvidersByPrice({required bool ascending}) {
    setState(() {
      nearestProviders.sort((a, b) => ascending
          ? a.pricePerHour.compareTo(b.pricePerHour)
          : b.pricePerHour.compareTo(a.pricePerHour));
    });
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Step 1: Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentLocation = "Location service disabled";
      });
      return;
    }

    // Step 2: Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _currentLocation = "Permission denied";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _currentLocation = "Permission permanently denied";
      });
      return;
    }

    // Step 3: Get the current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Step 4: Get address details from coordinates
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      setState(() {
        // 🧭 Full detailed place name
        _currentLocation =
            "${place.name ?? ''}, ${place.street ?? ''}, ${place.subLocality ?? ''}, "
                    "${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}"
                .replaceAll(RegExp(r', ,'), ',')
                .trim();
      });
    } else {
      setState(() {
        _currentLocation = "Unknown location";
      });
    }
  }

  void sortProvidersByExperience({required bool ascending}) {
    setState(() {
      nearestProviders.sort((a, b) => ascending
          ? a.experience.compareTo(b.experience)
          : b.experience.compareTo(a.experience));
    });
  }

  void showFilterOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
          ),
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Sort by",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Urbanist",
                  )),
              SizedBox(height: 15.h),
              _buildFilterOption(
                  "priceAsc", "Price: Low to High", Icons.arrow_upward),
              _buildFilterOption(
                  "priceDesc", "Price: High to Low", Icons.arrow_downward),
              _buildFilterOption("experienceAsc", "Experience: Low to High",
                  Icons.star_border),
              _buildFilterOption(
                  "experienceDesc", "Experience: High to Low", Icons.star),
            ],
          ),
        );
      },
    );
  }

  String selectedSortOption = '';

  Widget _buildFilterOption(String value, String title, IconData icon) {
    return RadioListTile<String>(
      value: value,
      groupValue: selectedSortOption,
      onChanged: (val) {
        setState(() => selectedSortOption = val!);
        if (val == "priceAsc") {
          sortProvidersByPrice(ascending: true);
        } else if (val == "priceDesc") {
          sortProvidersByPrice(ascending: false);
        } else if (val == "experienceAsc") {
          sortProvidersByExperience(ascending: true);
        } else {
          sortProvidersByExperience(ascending: false);
        }
        Navigator.pop(context);
      },
      activeColor: AppColors.logocolor,
      title: Row(
        children: [
          Icon(icon, color: AppColors.logocolor, size: 18.sp),
          SizedBox(width: 8.w),
          Text(title,
              style: TextStyle(fontFamily: "Urbanist", fontSize: 15.sp)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.category;

    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: CustomScrollView(
        slivers: [
          /// ✅ AppBar (kept exactly the same)
          SliverAppBar(
            expandedHeight: 250.h,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 2,
            leading: Container(
              margin: EdgeInsets.only(left: 16.w, top: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4.r,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded,
                    color: AppColors.logocolor, size: 20.sp),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(bottom: 16.h),
              centerTitle: true,
              title: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6.r,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  category['catename'],
                  style: TextStyle(
                    color: AppColors.logocolor,
                    fontFamily: 'Urbanist',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.logocolor.withOpacity(0.8),
                      AppColors.logocolor.withOpacity(0.4),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30.w,
                      top: -30.h,
                      child: Container(
                        width: 150.w,
                        height: 150.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      left: -20.w,
                      bottom: -20.h,
                      child: Container(
                        width: 100.w,
                        height: 100.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              category['imageURL'],
                              height: 60.h,
                              width: 60.w,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(Icons.location_on, color: Colors.white, size: 16.sp),
                              // SizedBox(width: 5.w),
                              Flexible(
                                child: Text(
                                  _currentLocation,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Urbanist',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// ✅ Provider count
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Text(
                "${nearestProviders.length} nearest ${widget.categoryName} providers found",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Urbanist",
                ),
              ),
            ),
          ),

          /// ✅ Provider List
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => _buildProviderCard(nearestProviders[i], ctx),
              childCount: nearestProviders.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderCard(ProviderModel provider, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProviderDetailsScreen(provider: provider),
          ),
        );
      },
      child: Transform.scale(
        scale: _scaleFactor,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8.r,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 👤 Provider Image
                    Container(
                      height: 80.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: Colors.grey.shade300,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: provider.imageUrl.isNotEmpty
                            ? Image.network(
                                provider.imageUrl,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.person,
                                color: Colors.white, size: 40),
                      ),
                    ),
                    SizedBox(width: 15.w),

                    /// Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Name + Price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                provider.fullName,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Urbanist',
                                ),
                              ),
                              Text(
                                '\$${provider.pricePerHour}',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColors.logocolor,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Urbanist',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          // ⭐ Dynamic Rating from Firestore
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("Provider")
                                .doc(provider.id)
                                .collection("Reviews")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Row(
                                  children: [
                                    Icon(Icons.star,
                                        color: Colors.amber, size: 16.sp),
                                    SizedBox(width: 4.w),
                                    Text("...",
                                        style: TextStyle(fontSize: 14.sp)),
                                  ],
                                );
                              }
                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return Row(
                                  children: [
                                    Icon(Icons.star_border,
                                        color: Colors.grey, size: 16.sp),
                                    SizedBox(width: 4.w),
                                    Text(
                                      "No reviews",
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.grey[600],
                                        fontFamily: 'Urbanist',
                                      ),
                                    ),
                                  ],
                                );
                              }
                              var reviews = snapshot.data!.docs;
                              int totalReviews = reviews.length;
                              double avgRating = 0.0;
                              for (var r in reviews) {
                                avgRating += (r['rating'] ?? 0).toDouble();
                              }
                              avgRating = avgRating / totalReviews;
                              return Row(
                                children: [
                                  Icon(Icons.star,
                                      color: Colors.amber, size: 16.sp),
                                  SizedBox(width: 4.w),
                                  Text(
                                    avgRating.toStringAsFixed(1),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey[700],
                                      fontFamily: 'Urbanist',
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    "($totalReviews reviews)",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.blueGrey,
                                      fontFamily: 'Urbanist',
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(height: 8.h),
                          SizedBox(height: 5.h),
                          Text(
                            provider.description,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                              fontFamily: 'Urbanist',
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Divider(height: 1.h, color: Colors.grey[200]),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left side: icon + location text
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on,
                              size: 16.sp, color: AppColors.logocolor),
                          SizedBox(width: 5.w),
                          Expanded(
                            child: Text(
                              provider.location,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                                fontFamily: 'Urbanist',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w), // Right side: View Profile button
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: AppColors.logocolor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'View Profile',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.logocolor,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
