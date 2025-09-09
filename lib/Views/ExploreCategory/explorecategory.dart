import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/Models/ProviderModel.dart';
import 'package:talk/Views/ProviderDetails/providerdetails.dart';
import 'package:talk/constants/colors.dart';
import 'package:talk/constants/image.dart';
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
  List<ProviderModel> filteredProviders = [];
  TextEditingController searchController = TextEditingController();
  String selectedSortOption = '';
  double _scaleFactor = 1.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProviders();
  }

  Future<void> _loadProviders() async {
    setState(() {
      _isLoading = true;
    });

    // Static list of providers
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate loading

    setState(() {
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
          imageUrl: AppImages.person1,
        ),
        ProviderModel(
          id: '2',
          fullName: ' Ahmed',
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
          imageUrl: AppImages.person2,
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
          imageUrl: AppImages.person3,
        ),
      ];
      filteredProviders = providers;
      _isLoading = false;
    });
  }

  void filterProviders(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredProviders = providers;
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
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r),
              topRight: Radius.circular(30.r),
            ),
          ),
          padding: EdgeInsets.only(
            top: 20.h,
            left: 20.w,
            right: 20.w,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Sort by',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Urbanist',
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20.h),
              _buildFilterOption('priceAsc', 'Price: Low to High', Icons.arrow_upward),
              _buildFilterOption('priceDesc', 'Price: High to Low', Icons.arrow_downward),
              _buildFilterOption('experienceAsc', 'Experience: Low to High', Icons.star_border),
              _buildFilterOption('experienceDesc', 'Experience: High to Low', Icons.star),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String value, String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Container(
        decoration: BoxDecoration(
          color: selectedSortOption == value ? AppColors.logocolor.withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: RadioListTile<String>(
          activeColor: AppColors.logocolor,
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
          title: Row(
            children: [
              Icon(icon, color: AppColors.logocolor, size: 20.sp),
              SizedBox(width: 10.w),
              Text(
                title,
                style: TextStyle(
                  color: Colors.black87,
                  fontFamily: 'Urbanist',
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          value: value,
          groupValue: selectedSortOption,
          onChanged: (value) {
            setState(() {
              selectedSortOption = value!;
            });

            if (value == 'priceAsc') {
              sortProvidersByPrice(ascending: true);
            } else if (value == 'priceDesc') {
              sortProvidersByPrice(ascending: false);
            } else if (value == 'experienceAsc') {
              sortProvidersByExperience(ascending: true);
            } else if (value == 'experienceDesc') {
              sortProvidersByExperience(ascending: false);
            }

            Navigator.pop(context);
          },
        ),
      ),
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

  @override
  Widget build(BuildContext context) {
    final category = widget.category;

    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: CustomScrollView(
        slivers: [
          // Modern App Bar Section
          SliverAppBar(
            expandedHeight: 180.h,
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
            actions: [
              Container(
                margin: EdgeInsets.only(right: 16.w, top: 8.h),
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
                  icon: Icon(Icons.favorite_border_rounded,
                      color: AppColors.logocolor, size: 22.sp),
                  onPressed: () {},
                ),
              ),
            ],
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
                          // Container(
                          //   padding: EdgeInsets.all(16.r),
                          //   decoration: BoxDecoration(
                          //     color: Colors.white.withOpacity(0.2),
                          //     shape: BoxShape.circle,
                          //   ),
                          //   child: Image.asset(
                          //     category['imageURL'],
                          //     height: 60.h,
                          //     width: 60.w,
                          //     color: Colors.white,
                          //   ),
                          // ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_on, color: Colors.white, size: 16.sp),
                              SizedBox(width: 5.w),
                              Text(
                                "Lahore, Pakistan",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Urbanist',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Search and filter section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8.r,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: filterProviders,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
                    border: InputBorder.none,
                    hintText: 'Search providers...',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Urbanist',
                      fontSize: 14.sp,
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    suffixIcon: GestureDetector(
                      onTap: showFilterOptions,
                      child: Container(
                        padding: EdgeInsets.all(10.r),
                        child: Icon(Icons.filter_list_rounded, color: Colors.grey),
                      ),
                    ),
                  ),
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ),
          ),

          // Results count
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Text(
                "${filteredProviders.length} Providers Available",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                  fontFamily: 'Urbanist',
                ),
              ),
            ),
          ),

          // Providers list
          _isLoading
              ? SliverToBoxAdapter(
            child: Container(
              height: 300.h,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.logocolor),
                ),
              ),
            ),
          )
              : filteredProviders.isEmpty
              ? SliverToBoxAdapter(
            child: Container(
              height: 300.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sentiment_dissatisfied, size: 60.sp, color: Colors.grey[400]),
                  SizedBox(height: 15.h),
                  Text(
                    "No providers found",
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Urbanist',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Try adjusting your search or filters",
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Urbanist',
                      fontSize: 14.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
              : SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final provider = filteredProviders[index];
                return _buildProviderCard(provider, context);
              },
              childCount: filteredProviders.length,
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
                    // Provider image
                    Container(
                      height: 80.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        image: DecorationImage(
                          image: AssetImage(provider.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 15.w),

                    // Provider details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                '\$${provider.pricePerHour}/hr',
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
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 16.sp),
                              SizedBox(width: 4.w),
                              Text(
                                '4.5',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[700],
                                  fontFamily: 'Urbanist',
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Icon(Icons.work, color: Colors.grey, size: 16.sp),
                              SizedBox(width: 4.w),
                              Text(
                                '${provider.experience} yrs',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[700],
                                  fontFamily: 'Urbanist',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
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
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16.sp, color: AppColors.logocolor),
                        SizedBox(width: 5.w),
                        Text(
                          provider.location,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                            fontFamily: 'Urbanist',
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
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