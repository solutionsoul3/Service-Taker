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
import '../Map_Location_Picker/map_location_picker.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  File? _selectedImage;
  bool _isEditing = false;
  bool _isSaving = false;

  UserModel? currentUser;
  double? _latitude;
  double? _longitude;

  // ✅ Initialize controllers immediately
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // ✅ Load user info from Firestore (including location)
  Future<void> _loadUserData() async {
    UserService userService = UserService();
    UserModel? user = await userService.getUserDetails();

    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('User')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data()!;

        setState(() {
          currentUser = user;

          _nameController.text = data['name'] ?? '';
          _phoneController.text = data['phoneNumber'] ?? '';
          _bioController.text = data['bio'] ?? '';
          _locationController.text = data['location'] ?? '';

          _latitude = (data['latitude'] != null)
              ? (data['latitude'] as num).toDouble()
              : null;
          _longitude = (data['longitude'] != null)
              ? (data['longitude'] as num).toDouble()
              : null;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  Future<void> _pickLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MapLocationPickerScreen(),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _locationController.text = result["address"];
        _latitude = result["lat"];
        _longitude = result["lng"];
      });
    }
  }

  Future<void> _updateUserData() async {
    if (currentUser == null) return;

    setState(() => _isSaving = true);
    try {
      final userDocRef =
      FirebaseFirestore.instance.collection('User').doc(currentUser!.uid);

      String? imageUrl = currentUser!.imageUrl;
      if (_selectedImage != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images/${currentUser!.uid}.jpg');
        await storageRef.putFile(_selectedImage!);
        imageUrl = await storageRef.getDownloadURL();
      }

      await userDocRef.set({
        'name': _nameController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'bio': _bioController.text.trim(),
        'imageUrl': imageUrl,
        'email': currentUser!.email,
        'location': _locationController.text.trim(),
        'latitude': _latitude,
        'longitude': _longitude,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Success"),
            content: const Text("Your profile has been saved successfully!"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      debugPrint("❌ Error updating user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save profile. Please try again.")),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
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
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
                _isEditing ? CupertinoIcons.check_mark : CupertinoIcons.pen,
                color: Colors.white),
            onPressed: () async {
              if (_isEditing) await _updateUserData();
              setState(() => _isEditing = !_isEditing);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Profile Details',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 10.h),
              Text('Change the following details and save them.',
                  style: TextStyle(fontSize: 13.sp)),
              SizedBox(height: 20.h),

              /// Image Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Image',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14.sp)),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            height: 140.h,
                            width: 140.w,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Icon(Icons.add_a_photo,
                                size: 35.sp, color: Colors.grey),
                          ),
                        ),
                        if (_selectedImage != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Image.file(
                              _selectedImage!,
                              height: 140.h,
                              width: 140.w,
                              fit: BoxFit.cover,
                            ),
                          )
                        else if (currentUser?.imageUrl != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Image.network(
                              currentUser!.imageUrl!,
                              height: 140.h,
                              width: 140.w,
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          Container(
                            height: 140.h,
                            width: 140.w,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: const Icon(Icons.person,
                                size: 40, color: Colors.white),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              _buildEditableField(
                  "Full Name", Icons.person, _nameController,
                  editable: _isEditing),
              SizedBox(height: 20.h),
              _buildStaticField("Email", Icons.email,
                  currentUser?.email ?? 'Loading...'),
              SizedBox(height: 20.h),
              _buildEditableField(
                  "Phone Number", Icons.phone, _phoneController,
                  editable: _isEditing),
              SizedBox(height: 20.h),
              _buildEditableField(
                  "Short Biography", Icons.description, _bioController,
                  editable: _isEditing, maxLines: 3),
              SizedBox(height: 20.h),
              _buildLocationField(),

              SizedBox(height: 40.h),
              Center(
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.green)
                    : CustomElevatedButton(
                  text: 'Save',
                  onPressed: () async {
                    await _updateUserData();
                    setState(() => _isEditing = false);
                  },
                  height: 45.h,
                  width: 230.w,
                  backgroundColor: AppColors.logocolor,
                  textColor: Colors.white,
                  borderRadius: 10.r,
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(
      String label, IconData icon, TextEditingController controller,
      {bool editable = false, int maxLines = 1}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.grey, size: 19.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: editable
                    ? TextField(
                  controller: controller,
                  maxLines: maxLines,

                  decoration:
                  const InputDecoration(border: InputBorder.none),
                )
                    : Text(
                    controller.text.isNotEmpty
                        ? controller.text
                        : "No data available",
                    style:
                    TextStyle(fontSize: 13.sp, color: Colors.black)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStaticField(String label, IconData icon, String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey, size: 19.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14.sp)),
                SizedBox(height: 8.h),
                Text(value.isNotEmpty ? value : "No data available",
                    style: TextStyle(fontSize: 13.sp)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationField() {
    return GestureDetector(
      onTap: _pickLocation,
      child: AbsorbPointer(
        child: _buildEditableField(
          "Location",
          Icons.location_on,
          _locationController,
          maxLines: 2,
          editable: true,
        ),
      ),
    );
  }
}
