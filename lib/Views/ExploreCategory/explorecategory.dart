import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Constants/colors.dart';
import '../../Controller/provider-controller.dart';
import '../../Models/ProviderModel.dart';
import '../ProviderDetails/providerdetails.dart';

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

  List<ProviderModel> filteredProviders = [];
  TextEditingController searchController = TextEditingController();
  String selectedSortOption = '';
  double _scaleFactor = 1.0;

  @override
  void initState() {
    super.initState();
    controller
        .fetchProvidersByCategory(widget.categoryName); // Firestore filter
  }

  void filterProviders(String query) {
    final providers = controller.providers;
    if (query.isEmpty) {
      setState(() => filteredProviders = providers);
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

  void sortProvidersByPrice({required bool ascending}) {
    setState(() {
      filteredProviders.sort((a, b) => ascending
          ? a.pricePerHour.compareTo(b.pricePerHour)
          : b.pricePerHour.compareTo(a.pricePerHour));
    });
  }

  void sortProvidersByExperience({required bool ascending}) {
    setState(() {
      filteredProviders.sort((a, b) => ascending
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
          // Modern App Bar Section
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
                              Icon(Icons.location_on,
                                  color: Colors.white, size: 16.sp),
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
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
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
                        child:
                            Icon(Icons.filter_list_rounded, color: Colors.grey),
                      ),
                    ),
                  ),
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ),
          ),
          // Provider count
          SliverToBoxAdapter(
            child: Obx(() => Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Text(
                    "${controller.providers.length} ${widget.categoryName} providers available",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Urbanist",
                    ),
                  ),
                )),
          ),

          // Provider list
          Obx(() {
            if (controller.isLoading.value) {
              return SliverToBoxAdapter(
                child: SizedBox(
                  height: 250.h,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(AppColors.logocolor),
                    ),
                  ),
                ),
              );
            }

            if (controller.providers.isEmpty) {
              return SliverToBoxAdapter(
                child: SizedBox(
                  height: 250.h,
                  child: Center(
                    child: Text("No ${widget.categoryName} providers found",
                        style:
                            TextStyle(fontSize: 16.sp, fontFamily: "Urbanist")),
                  ),
                ),
              );
            }

            final data = filteredProviders.isEmpty
                ? controller.providers
                : filteredProviders;

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => _buildProviderCard(data[i], ctx),
                childCount: data.length,
              ),
            );
          }),
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
                          image: NetworkImage(provider.imageUrl),
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
                              Icon(Icons.star,
                                  color: Colors.amber, size: 16.sp),
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
                        Icon(Icons.location_on,
                            size: 16.sp, color: AppColors.logocolor),
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
