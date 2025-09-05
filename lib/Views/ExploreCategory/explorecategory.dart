import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/Models/ProviderModel.dart';
import 'package:talk/Views/ProviderDetails/providerdetails.dart';
import 'package:talk/constants/colors.dart';
import 'package:talk/widgets/reusableboxdecoration.dart';
import 'package:talk/widgets/textfields.dart';

class ExploreCategory extends StatefulWidget {
  final dynamic category;

  const ExploreCategory({
    super.key,
    required this.category,
  });

  @override
  State<ExploreCategory> createState() => _ExploreCategoryState();
}

class _ExploreCategoryState extends State<ExploreCategory>
    with SingleTickerProviderStateMixin {
  List<ProviderModel> providers = [];
  List<ProviderModel> filteredProviders = []; // For filtered results
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Static list of providers
    providers = [
      ProviderModel(
        id: '1',
        fullName: 'Ali Khan',
        email: 'ali@example.com',
        contactNumber: '03001234567',
        formFilled: true,
        location: 'Lahore',
        service: 'Electrician',
        status: 'active',
        pricePerHour: 1500,
        experience: '5',
        description: 'Expert electrician for all types of wiring and repair.',
        experienceDescription: '5 years of residential and commercial work.',
        imageUrl: 'assets/images/homepics/slider1.jpg', // Online image
      ),
      ProviderModel(
        id: '2',
        fullName: 'Sara Ahmed',
        email: 'sara@example.com',
        contactNumber: '03007654321',
        formFilled: true,
        location: 'Karachi',
        service: 'Plumber',
        status: 'active',
        pricePerHour: 1200,
        experience: '3',
        description: 'Professional plumber available 24/7.',
        experienceDescription: 'Worked on 100+ plumbing projects.',
        imageUrl: 'assets/images/homepics/slider2.jpg',
      ),
      ProviderModel(
        id: '3',
        fullName: 'Usman Iqbal',
        email: 'usman@example.com',
        contactNumber: '03111234567',
        formFilled: true,
        location: 'Islamabad',
        service: 'Painter',
        status: 'active',
        pricePerHour: 2000,
        experience: '7',
        description: 'Certified house painter & decorator.',
        experienceDescription: '7 years of professional painting services.',
        imageUrl: 'assets/images/homepics/slider3.jpg',
      ),
    ];

    filteredProviders = providers;
  }

  String selectedSortOption = ''; // Holds the currently selected sorting option

  Future<void> fetchProviders() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Provider')
        .where('category', isEqualTo: widget.category.catename)
        .get();

    print(
        "Fetched ${snapshot.docs.length} providers for category: ${widget.category.catename}");

    final List<ProviderModel> fetchedProviders = snapshot.docs
        .map((doc) =>
            ProviderModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();

    setState(() {
      providers = fetchedProviders;
      filteredProviders = providers; // Initially display all providers
    });
  }

  void filterProviders(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredProviders =
            providers; // Reset to full list when search is empty
      });
      return;
    }

    setState(() {
      filteredProviders = providers.where((provider) {
        final fullName = provider.fullName.toLowerCase();
        final description = provider.description.toLowerCase();
        final searchQuery = query.toLowerCase();

        return fullName.contains(searchQuery) ||
            description.contains(searchQuery);
      }).toList();
    });
  }

  void showFilterOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50.r)),
      ),
      builder: (BuildContext context) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 1100),
          curve: Curves.easeInOutCubicEmphasized,
          padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 20.h),
          height: 350.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Sort by:',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Urbanist',
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10.h),
              RadioListTile<String>(
                activeColor: AppColors.logocolor, // Different active color
                title: Row(
                  children: [
                    Text(
                      'Ascending order of Price',
                      style: TextStyle(
                        color: AppColors.logocolor,
                        fontFamily: 'Urbanist',
                        fontSize: 16.sp,
                      ),
                    ),
                    const Icon(Icons.attach_money, color: AppColors.logocolor),
                  ],
                ),
                value: 'priceAsc',
                groupValue: selectedSortOption,
                onChanged: (value) {
                  setState(() {
                    selectedSortOption = value!;
                  });
                  sortProvidersByPrice(ascending: true);
                  Navigator.pop(context); // Close modal
                },
              ),
              RadioListTile<String>(
                activeColor: AppColors.logocolor, // Different active color
                title: Row(
                  children: [
                    Text(
                      'Descending order of Price',
                      style: TextStyle(
                        color: AppColors.logocolor,
                        fontFamily: 'Urbanist',
                        fontSize: 16.sp,
                      ),
                    ),
                    const Icon(Icons.attach_money, color: AppColors.logocolor),
                  ],
                ),
                value: 'priceDesc',
                groupValue: selectedSortOption,
                onChanged: (value) {
                  setState(() {
                    selectedSortOption = value!;
                  });
                  sortProvidersByPrice(ascending: false);
                  Navigator.pop(context); // Close modal
                },
              ),
              RadioListTile<String>(
                activeColor: AppColors.logocolor, // Different active color
                title: Row(
                  children: [
                    Text(
                      'Ascending order of Experience',
                      style: TextStyle(
                        color: AppColors.logocolor,
                        fontFamily: 'Urbanist',
                        fontSize: 16.sp,
                      ),
                    ),
                    const Icon(Icons.star, color: AppColors.logocolor),
                  ],
                ),
                value: 'experienceAsc',
                groupValue: selectedSortOption,
                onChanged: (value) {
                  setState(() {
                    selectedSortOption = value!;
                  });
                  sortProvidersByExperience(ascending: true);
                  Navigator.pop(context); // Close modal
                },
              ),
              RadioListTile<String>(
                activeColor: AppColors.logocolor, // Different active color
                title: Row(
                  children: [
                    Text(
                      'Descending order of Experience',
                      style: TextStyle(
                        color: AppColors.logocolor,
                        fontFamily: 'Urbanist',
                        fontSize: 16.sp,
                      ),
                    ),
                    const Icon(Icons.star, color: AppColors.logocolor),
                  ],
                ),
                value: 'experienceDesc',
                groupValue: selectedSortOption,
                onChanged: (value) {
                  setState(() {
                    selectedSortOption = value!;
                  });
                  sortProvidersByExperience(ascending: false);
                  Navigator.pop(context); // Close modal
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void sortProvidersByPrice({required bool ascending}) {
    setState(() {
      filteredProviders.sort((a, b) {
        if (ascending) {
          return a.pricePerHour.compareTo(b.pricePerHour);
        } else {
          return b.pricePerHour.compareTo(a.pricePerHour);
        }
      });
    });
  }

  void sortProvidersByExperience({required bool ascending}) {
    setState(() {
      filteredProviders.sort((a, b) {
        if (ascending) {
          return a.experience.compareTo(b.experience);
        } else {
          return b.experience.compareTo(a.experience);
        }
      });
    });
  }

  double _scaleFactor = 1.0;
  @override
  Widget build(BuildContext context) {
    final category = widget.category; // Access the passed category data

    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: Stack(
        children: [
          BackgroundContainer(
            child: Padding(
              padding: EdgeInsets.only(top: 350.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: const Column(
                  children: [],
                ),
              ),
            ),
          ),
          Container(
            height: 250.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.logocolor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.r),
                bottomRight: Radius.circular(20.r),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 50.h),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            category['catename'],
                            // Use category name
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Image.asset(
                    category['imageURL'],
                    fit: BoxFit.cover,
                    height: 50.h,
                    width: 50.w,
                    color: Colors.white,
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 100.w,
                          ),
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                          SizedBox(width: 8.sp),
                          Text(
                            "Lahore, Pakistan",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.location_on,
                            color: Colors.transparent,
                            size: 24.sp,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 220.h,
            left: 40.w,
            child: Container(
              height: 50.h,
              width: 320.w,
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
                controller: searchController,
                onChanged: filterProviders,
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
                  suffixIcon: GestureDetector(
                    onTap: showFilterOptions, // Show animated filter options
                    child: const Icon(
                      Icons.filter_list,
                      color: Colors.grey,
                    ),
                  ),
                ),
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          ),
          Positioned(
            top: 280.h,
            left: 10.w,
            right: 10.w,
            child: SizedBox(
              height: 600.h,
              child: filteredProviders.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.sentiment_dissatisfied,
                            size: 50.sp, color: Colors.grey),
                        SizedBox(height: 10.h),
                        Text(
                          "No providers found.",
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Urbanist',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: filteredProviders.length,
                      itemBuilder: (context, index) {
                        final provider = filteredProviders[index];
                        return GestureDetector(
                          onTapDown: (_) {
                            setState(() {
                              _scaleFactor = 0.95; // Scale down on tap
                            });
                          },
                          onTapUp: (_) {
                            setState(() {
                              _scaleFactor = 1.0; // Scale back up on release
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProviderDetailsScreen(provider: provider),
                              ),
                            );
                          },
                          onTapCancel: () {
                            setState(() {
                              _scaleFactor = 1.0;
                            });
                          },
                          child: Transform.scale(
                            scale: _scaleFactor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ReusableBoxDecoration(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          provider.fullName,
                                          style: reusableTextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '\$${provider.pricePerHour}',
                                          style: reusableTextStyle(
                                            fontSize: 14.sp,
                                            color: AppColors.logocolor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        Container(
                                          height: 80.h,
                                          width: 100.w,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 4.r,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: Image.asset(
                                              provider.imageUrl,
                                              fit: BoxFit.cover,
                                              // loadingBuilder:
                                              //     (BuildContext context,
                                              //         Widget child,
                                              //         ImageChunkEvent?
                                              //             loadingProgress) {
                                              //   if (loadingProgress == null)
                                              //     return child; // If loading is done, return the child (image).
                                              //   return Center(
                                              //     child:
                                              //         CircularProgressIndicator(
                                              //       value: loadingProgress
                                              //                   .expectedTotalBytes !=
                                              //               null
                                              //           ? loadingProgress
                                              //                   .cumulativeBytesLoaded /
                                              //               (loadingProgress
                                              //                       .expectedTotalBytes ??
                                              //                   1)
                                              //           : null,
                                              //     ),
                                              //   );
                                              // },
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object error,
                                                      StackTrace? stackTrace) {
                                                return Center(
                                                  child: Icon(
                                                    Icons
                                                        .error_outline, // Sorry icon
                                                    color: Colors
                                                        .red, // Change color to fit your design
                                                    size: 40
                                                        .sp, // Adjust the size as needed
                                                  ),
                                                );
                                              },
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
                                                provider.description,
                                                textAlign: TextAlign.center,
                                                style: reusableTextStyle(
                                                  fontSize: 14.sp,
                                                  color: AppColors.logocolor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                provider.experienceDescription,
                                                maxLines: 4,
                                                overflow: TextOverflow.ellipsis,
                                                style: reusableTextStyle(
                                                  fontSize: 11.sp,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
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
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
