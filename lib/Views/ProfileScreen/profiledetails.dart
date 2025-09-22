import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talk/Models/UserModel.dart';
import 'package:talk/constants/colors.dart';
import 'package:talk/constants/reusable_button.dart';
import 'package:talk/utility/user_service.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  File? _selectedImage;
  bool _isEditing = false;
  UserModel? currentUser;

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    UserService userService = UserService();
    UserModel? user = await userService.getUserDetails();
    setState(() {
      if (user != null) {
        currentUser = user;
        _nameController = TextEditingController(text: currentUser!.name);
        // _phoneController =
        //     TextEditingController(text: currentUser!.phoneNumber);
        _bioController = TextEditingController(text: currentUser!.bio ?? '');
      } else {
       
      }
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateUserData() async {
    // Reference to Firestore and Storage
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(currentUser!.uid);
    String? imageUrl;

    // Upload new image to Firebase Storage if a new image is selected
    if (_selectedImage != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images/${currentUser!.uid}');
      await storageRef.putFile(_selectedImage!);
      imageUrl = await storageRef.getDownloadURL();
    }

    // Update user document
    await userDocRef.set(
        {
          'name': _nameController.text,
          'phoneNumber': _phoneController.text,
          'bio': _bioController.text,
          'imageUrl': imageUrl ??
              currentUser!.imageUrl, // Keep existing if no new image
        },
        SetOptions(
            merge:
                true)); // Merge to update existing fields and create new ones
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Profile',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.bold,
              fontSize: 20.sp),
        ),
        backgroundColor: AppColors.logocolor,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
                _isEditing ? CupertinoIcons.check_mark : CupertinoIcons.pen,
                color: Colors.white),
            onPressed: () async {
              if (_isEditing) {
                // Call the update function
                await _updateUserData();
              }
              setState(() {
                _isEditing = !_isEditing; // Toggle edit mode
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile Details',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Urbanist',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Change the following details and save them.',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Urbanist',
                        fontSize: 13.sp),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Image selection
              Container(
                height: 250.h,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r)),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Image',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Urbanist',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold)),

                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              height: 150.h,
                              width: 150.w,
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 241, 239, 239),
                                  borderRadius: BorderRadius.circular(10.r)),
                              child: Center(
                                child: Icon(Icons.add_a_photo,
                                    size: 40.sp, color: Colors.grey),
                              ),
                            ),
                          ),
                          if (_selectedImage != null) // Show selected image
                            Container(
                              height: 150.h,
                              width: 150.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.r),
                                image: DecorationImage(
                                    image: FileImage(_selectedImage!),
                                    fit: BoxFit.cover),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Full Name
              Container(
                height: _isEditing ? 120.h : 80.h,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r)),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Full Name',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Urbanist',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.person, color: Colors.grey, size: 19.sp),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: _isEditing
                                ? TextField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                        hintText: 'Enter your name'))
                                : Text(
                                    currentUser != null
                                        ? currentUser!.name
                                        : 'Loading...',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Urbanist',
                                        fontSize: 13.sp)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Email
              Container(
                height: 80.h,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r)),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Urbanist',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.email, color: Colors.grey, size: 19.sp),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                                currentUser != null
                                    ? currentUser!.email
                                    : 'Loading...',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Urbanist',
                                    fontSize: 13.sp)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Phone Number
              Container(
                height: _isEditing ? 120.h : 80.h,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r)),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Phone Number',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Urbanist',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.phone, color: Colors.grey, size: 19.sp),
                          SizedBox(width: 8.w),
                          // Expanded(
                          //   child: _isEditing
                          //       ? TextField(
                          //           controller: _phoneController,
                          //           decoration: const InputDecoration(
                          //               border: OutlineInputBorder(),
                          //               hintText: 'Enter your phone number'),
                          //           keyboardType: TextInputType.phone)
                          //       : Text(
                          //           currentUser != null
                          //               ? currentUser!.phoneNumber
                          //               : 'Loading...',
                          //           style: TextStyle(
                          //               color: Colors.black,
                          //               fontFamily: 'Urbanist',
                          //               fontSize: 13.sp)),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Short Biography
              Container(
                height: _isEditing ? 220.h : 100.h,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r)),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Short Biography',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Urbanist',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.description,
                              color: Colors.grey, size: 19.sp),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: _isEditing
                                ? TextField(
                                    controller: _bioController,
                                    maxLines: 3,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Enter a short biography'))
                                : Text(
                                    currentUser != null
                                        ? currentUser!.bio ?? ''
                                        : 'Loading...',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Urbanist',
                                        fontSize: 13.sp)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Save and Reset buttons
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomElevatedButton(
                    text: 'Save',
                    onPressed: () async {
                      await _updateUserData();
                      setState(() {
                        _isEditing = false; // Exit edit mode after saving
                      });
                    },
                    height: 40.h,
                    width: 230.w,
                    backgroundColor: AppColors.logocolor,
                    textColor: Colors.white,
                    borderRadius: 10.r,
                  ),
                  SizedBox(width: 20.w),
                  CustomElevatedButton(
                    text: 'Reset',
                    onPressed: () {
                      // Reset the form fields
                      setState(() {
                        _nameController.text = currentUser?.name ?? '';
                      //  _phoneController.text = currentUser?.phoneNumber ?? '';
                        _bioController.text = currentUser?.bio ?? '';
                        _selectedImage = null; // Reset selected image
                      });
                    },
                    height: 40.h,
                    width: 100.w,
                    backgroundColor: Colors.grey,
                    textColor: Colors.black,
                    borderRadius: 10.r,
                  ),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
