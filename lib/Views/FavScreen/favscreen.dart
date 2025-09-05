import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:talk/Models/FavoriteProviderModel.dart';
import 'package:talk/constants/colors.dart';
import 'package:talk/constants/image.dart';
import 'package:talk/constants/reusable_button.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({super.key});

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  List<FavoriteItemModel> favoriteItems = [];
  String searchQuery = ''; // State variable for the search query

  @override
  void initState() {
    super.initState();
    fetchFavoriteItems();
  }

  Future<void> showDeleteConfirmationBottomSheet(
      BuildContext context, int index) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20.r),
          height: 220.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Delete Favorite',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Are you sure you want to remove ${favoriteItems[index].providerName} from your favorites?',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'Urbanist',
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomElevatedButton(
                    text: 'Remove',
                    onPressed: () async {
                      try {
                        final uid = FirebaseAuth.instance.currentUser?.uid;
                        final favoriteId = favoriteItems[index].providerId;

                        if (uid != null) {
                          // Delete the favorite item from Firestore
                          await FirebaseFirestore.instance
                              .collection('User')
                              .doc(uid)
                              .collection('Myfav')
                              .doc(favoriteId)
                              .delete();

                          // Store the provider name before removing the item from the list
                          final providerName =
                              favoriteItems[index].providerName;

                          // Remove the item from the local list
                          setState(() {
                            favoriteItems.removeAt(index);
                          });

                          // Show a dialog after successfully removing the favorite
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Success'),
                                content: Text(
                                  'Removed $providerName from favorites.',
                                  style: TextStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      } catch (e) {
                        print('Error removing favorite: $e');
                        // Show an error dialog in case of failure
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: const Text('Failed to remove favorite.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } finally {
                        // Close the bottom sheet after everything is done
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      }
                    },
                    height: 40.h,
                    width: 300.w,
                    backgroundColor: AppColors.logocolor,
                    textColor: Colors.white,
                    borderRadius: 10.r,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> fetchFavoriteItems() async {
    try {
      // Get the current user's UID
      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid != null) {
        // Fetch favorites from the user's document in Firestore
        final snapshot = await FirebaseFirestore.instance
            .collection('User')
            .doc(uid)
            .collection('Myfav')
            .get();

        // Map each document to the FavoriteItemModel
        final items = snapshot.docs
            .map((doc) => FavoriteItemModel.fromMap(doc.data()))
            .toList();

        setState(() {
          favoriteItems = items;
        });
      }
    } catch (e) {
      print('Error fetching favorite items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: Stack(
        children: [
          BackgroundContainer(
            child: Padding(
              padding: EdgeInsets.only(top: 270.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: favoriteItems.isEmpty
                          ? Center(
                              child: Text(
                                'No favorites added yet!',
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : searchQuery.isNotEmpty
                              ? ListView.builder(
                                  itemCount: favoriteItems
                                      .where((item) =>
                                          item.providerName
                                              .toLowerCase()
                                              .contains(searchQuery) ||
                                          '\$${item.price}'
                                              .contains(searchQuery) ||
                                          item.rating
                                              .toString()
                                              .contains(searchQuery))
                                      .length,
                                  itemBuilder: (context, index) {
                                    final favorite = favoriteItems
                                        .where((item) =>
                                            item.providerName
                                                .toLowerCase()
                                                .contains(searchQuery) ||
                                            '\$${item.price}'
                                                .contains(searchQuery) ||
                                            item.rating
                                                .toString()
                                                .contains(searchQuery))
                                        .toList()[index];

                                    return buildFavoriteItem(favorite, index);
                                  },
                                )
                              : ListView.builder(
                                  itemCount: favoriteItems.length,
                                  itemBuilder: (context, index) {
                                    final favorite = favoriteItems[index];
                                    return buildFavoriteItem(favorite, index);
                                  },
                                ),
                    ),
                  ],
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
                            'Favorites',
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
                  SvgPicture.asset(
                    AppImages.favicon,
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
                          SizedBox(width: 100.w),
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
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase(); // Update search query
                  });
                },
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
                  suffixIcon: const Icon(
                    Icons.filter_list,
                    color: Colors.grey,
                  ),
                ),
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFavoriteItem(FavoriteItemModel favorite, int index) {
    return Column(
      children: [
        Container(
          height: 150.h,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(15.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      height: 90.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 241, 239, 239),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.r),
                          topRight: Radius.circular(10.r),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.r),
                          topRight: Radius.circular(10.r),
                        ),
                        child: Image.network(
                          favorite.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      height: 25.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 241, 239, 239),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.r),
                          bottomRight: Radius.circular(10.r),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Offline',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Urbanist',
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          favorite.providerName,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Urbanist',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 120.w,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDeleteConfirmationBottomSheet(context, index);
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: 30.h,
                          width: 60.w,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 240, 211, 150),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 16,
                              ),
                              Text(
                                favorite.rating.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                  fontFamily: 'Urbanist',
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'Price',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13.sp,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Text(
                          '\$${favorite.price}',
                          style: TextStyle(
                            color: AppColors.logocolor,
                            fontSize: 13.sp,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      favorite.service,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13.sp,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }
}

class BackgroundContainer extends StatelessWidget {
  final Widget child;

  const BackgroundContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgcolor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: child,
    );
  }
}
