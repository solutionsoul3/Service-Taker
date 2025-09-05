import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:talk/Models/ProviderModel.dart';
import 'package:talk/Views/BookService/bookingsummary.dart';
import 'package:talk/constants/colors.dart';
import 'package:talk/constants/reusable_button.dart';
import 'package:talk/widgets/customcontainer.dart';
import 'package:talk/widgets/reusableboxdecoration.dart';

class BookServiceScreen extends StatefulWidget {
  final ProviderModel provider;

  const BookServiceScreen({super.key, required this.provider});
  @override
  _BookServiceScreenState createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends State<BookServiceScreen> {
  bool isAsSoonAsPossibleSelected = false;
  Map<String, String> selectedAvailability = {}; // Day -> Time range

  int selectedOption = 0;
  bool useOwnLocation = false;
  String userLocation = '';
  String hintText = '';
  String city = '';
  String country = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    print('Provider Data: ${widget.provider}');
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled.')),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied.')),
          );
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        setState(() {
          city = placemark.locality ?? '';
          country = placemark.country ?? '';
        });
      }
    } catch (e) {
      print('Error fetching location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching location.')),
      );
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
            'Book This Service',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: useOwnLocation,
                    onChanged: (value) {
                      setState(() {
                        useOwnLocation = value!;
                      });
                    },
                  ),
                  Text(
                    'Use my own location',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ],
              ),

              // Show TextField for user to enter their location if selected
              if (useOwnLocation)
                TextField(
                  onChanged: (value) {
                    setState(() {
                      userLocation = value; // Update user location
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your location here',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey,
                    fontFamily: 'Urbanist',
                  ),
                )
              else
                CustomContainer(
                  height: 100.h,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Your Current Location',
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Urbanist',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.black,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              '$city, $country',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontFamily: 'Urbanist',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              SizedBox(height: 20.h),
              CustomContainer(
                height: 80.h,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
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
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              hintText = value; // Update hint text
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter text here',
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 10.h),
                          ),
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey,
                            fontFamily: 'Urbanist',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              ReusableBoxDecoration(
                child: Column(
                  children: widget.provider.availability.map((availability) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Checkbox(
                          value: selectedAvailability
                              .containsKey(availability.day),
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                // If checked, add to selectedAvailability
                                selectedAvailability[availability.day] =
                                    '${availability.startTime} - ${availability.endTime}';
                              } else {
                                // If unchecked, remove from selectedAvailability
                                selectedAvailability.remove(availability.day);
                              }
                            });
                          },
                        ),
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
              ),

// Display selected days and times
              SizedBox(height: 20.h), // Add some space
              Text(
                'Selected Days and Times:',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              Column(
                children: selectedAvailability.entries.map((entry) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: Text(
                      '${entry.key}: ${entry.value}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 50.h),

              CustomElevatedButton(
                text: 'Continue',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingSummary(
                        selectedAvailability: selectedAvailability,
                        hintText: hintText,
                        userLocation: useOwnLocation ? userLocation : '',
                        providerLocation: widget.provider.location,
                        provider: widget.provider,
                      ),
                    ),
                  );
                },
                height: 40.h,
                width: 300.w,
                backgroundColor: AppColors.logocolor,
                textColor: Colors.white,
                borderRadius: 10.r,
              )
            ],
          ),
        ),
      ),
    );
  }
}
