import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talk/Views/auth/login_screen.dart';
import 'package:talk/constants/colors.dart';
import 'package:talk/constants/image.dart';
import 'package:talk/constants/reusable_button.dart';
import 'package:talk/widgets/textfields.dart';

import '../Map_Location_Picker/map_location_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  double? _selectedLat;
  double? _selectedLng;
  File? _selectedImage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  String _phoneNumber = '';
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Create user in Firebase Auth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Get user UID
      String uid = userCredential.user!.uid;

      // Initialize a variable for the image URL
      String? imageUrl;

      if (_selectedImage != null) {
        // Upload image to Firebase Storage
        final storageRef =
            FirebaseStorage.instance.ref().child('user_images/$uid.jpg');
        UploadTask uploadTask = storageRef.putFile(_selectedImage!);

        TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});
        imageUrl = await snapshot.ref.getDownloadURL();
      }

      await _firestore.collection('User').doc(uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        // 'phoneNumber': _phoneNumber,
        'uid': uid,
        'imageUrl': imageUrl,
        'location': _addressController.text,
        'latitude': _selectedLat,
        'longitude': _selectedLng,
      });

      Fluttertoast.showToast(msg: "Account created successfully!");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? "Failed to create account");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectLocationFromMap(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MapLocationPickerScreen()),
    );

    if (result != null) {
      setState(() {
        _addressController.text = result['address'];
        _selectedLat = result['lat'];
        _selectedLng = result['lng'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            BackgroundContainer(
              child: Padding(
                padding: EdgeInsets.only(top: 300.h),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),
                      Container(
                        height: 420.h,
                        width: 320.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 20.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFieldWithIcon(
                                labelText: "Full Name",
                                icon: Icons.person,
                                iconSize: 20.0,
                                hintText: "Enter your full name",
                                controller: _nameController,
                              ),
                              SizedBox(height: 10.h),
                              TextFieldWithIcon(
                                labelText: "Email Address",
                                icon: Icons.email,
                                iconSize: 20.0,
                                hintText: "Enter your email",
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailController,
                              ),
                              SizedBox(height: 10.h),
                              TextFieldWithIcon(
                                labelText: "Password",
                                icon: Icons.lock,
                                hintText: "Enter your password",
                                obscureText: true,
                                iconSize: 20.0,
                                controller: _passwordController,
                              ),
                              SizedBox(height: 10.h),
                              TextFieldWithIcon(
                                controller: _addressController,
                                labelText: "Location",
                                icon: Icons.location_on,
                                iconSize: 20.0,
                                hintText: "Enter location",
                                validator: (v) => v == null || v.isEmpty
                                    ? "Enter location"
                                    : null,
                                onTap: () => _selectLocationFromMap(context),
                                readOnly: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : CustomElevatedButton(
                              text: 'Register',
                              onPressed: _signUp,
                              height: 40.h,
                              width: 300.w,
                              backgroundColor: AppColors.logocolor,
                              textColor: Colors.white,
                              borderRadius: 10.r,
                            ),
                      SizedBox(height: 10.h),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                        child: Text(
                          "Already have an account?",
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            color: AppColors.logocolor,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Header
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
                    Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "Home Services",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.sp,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "Welcome to the best services provider",
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 190.h,
              left: 140.w,
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 110.h,
                  width: 120.w,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: AppColors.logocolor,
                      width: 4,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: _selectedImage != null
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                right: 8,
                                top: 8,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedImage = null;
                                    });
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Image.asset(
                            AppImages.applogo,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
