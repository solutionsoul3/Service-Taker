import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/Models/ProviderModel.dart';
import 'package:talk/Models/UserModel.dart';
import 'package:talk/constants/colors.dart';
import 'package:talk/constants/reusable_button.dart';
import 'package:talk/constants/successscreen.dart';
import 'package:talk/widgets/customcontainer.dart';
import 'package:talk/widgets/customrow.dart';

class BookingSummary extends StatefulWidget {
  final String userLocation;
  final String providerLocation;
  final String hintText;
  final ProviderModel provider;
  final Map<String, String> selectedAvailability;

  const BookingSummary({
    super.key,
    required this.userLocation,
    required this.providerLocation,
    required this.hintText,
    required this.provider,
    required this.selectedAvailability,
  });

  @override
  _BookingSummaryState createState() => _BookingSummaryState();
}

class _BookingSummaryState extends State<BookingSummary> {
  bool _isLoading = false;

  Future<void> _confirmBooking() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('No user is logged in');
        return;
      }
      String userId = user.uid;

      // Fetch the user data from Firestore
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('User').doc(userId).get();
      UserModel userModel = UserModel.fromDocument(userDoc);

      // Upload booking details to the user's "MyBooking" collection
      DocumentReference userBookingRef = await FirebaseFirestore.instance
          .collection('User')
          .doc(userId)
          .collection('MyBooking')
          .add({
        'userLocation': widget.userLocation,
        'hintText': widget.hintText,
        'status': 'Pending',
        'providerData': {
          'providerfullName': widget.provider.fullName,
          'providerservice': widget.provider.service,
          'providerdescription': widget.provider.description,
          'provideremail': widget.provider.email,
          'providercontactNumber': widget.provider.contactNumber,
          'providerexperience': widget.provider.experience,
          'providerimageUrl': widget.provider.imageUrl,
          'providerpricePerHour': widget.provider.pricePerHour,
        },
        'selectedAvailability': widget.selectedAvailability,
      });

      // Now upload booking details to the provider's "Bookings" collection
      DocumentReference providerBookingRef = await FirebaseFirestore.instance
          .collection('Provider')
          .doc(widget.provider.uid)
          .collection('Bookings')
          .add({
        'clientId': userId,
        'clientname': userModel.name,
        'clientemail': userModel.email,
       // 'clientphoneNumber': userModel.phoneNumber,
        'clientimageUrl': userModel.imageUrl ?? '',
        'clientLocation': widget.userLocation,
        'clienthintText': widget.hintText,
        'status': 'Pending',
        'selectedAvailability': widget.selectedAvailability,
        'fullName': widget.provider.fullName,
        'service': widget.provider.service,
        'description': widget.provider.description,
        'provideremail': widget.provider.email,
        'providerpricePerHour': widget.provider.pricePerHour,
        'userbookingdocid': userBookingRef.id,
        'provideracceptdocid': userBookingRef.id,
        // Store the user booking ID here
      });

      // Store the ProviderAcceptDocId in the user's booking document
      await userBookingRef.update({
        'provideracceptdocid':
            providerBookingRef.id, // Store the provider booking ID here
      });

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Booking confirmed successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CongratulationsScreen()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error uploading booking: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Text(
            'Booking Summary',
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'Urbanist',
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            // Booking details
            CustomContainer(
              height: 100.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomRow(
                      title: 'Booking Date',
                      value: '',
                      icon: Icons.date_range,
                    ),
                    Text(
                      'No date selected',
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.grey,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // User location
            SizedBox(height: 20.h),
            CustomContainer(
              height: 100.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomRow(
                      title: 'Your Address',
                      value: '',
                    ),
                    CustomRow(
                      title: widget.userLocation.isNotEmpty
                          ? widget.userLocation
                          : 'No address provided',
                      value: '',
                      icon: Icons.location_on,
                    ),
                  ],
                ),
              ),
            ),
            // Hint text
            SizedBox(height: 20.h),
            CustomContainer(
              height: 80.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hint',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                    CustomRow(
                      title: widget.hintText,
                      value: '',
                      icon: Icons.note,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(height: 29.h),
            CustomElevatedButton(
              text: _isLoading ? 'Loading...' : 'Confirm & Book Now',
              onPressed: () {
                _confirmBooking();
              },
              height: 40.h,
              width: 300.w,
              backgroundColor: AppColors.logocolor,
              textColor: Colors.white,
              borderRadius: 10.r,
            ),
          ],
        ),
      ),
    );
  }
}
