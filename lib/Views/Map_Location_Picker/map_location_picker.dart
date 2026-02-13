import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';

class MapLocationPickerScreen extends StatefulWidget {
  const MapLocationPickerScreen({super.key});

  @override
  State<MapLocationPickerScreen> createState() =>
      _MapLocationPickerScreenState();
}

class _MapLocationPickerScreenState extends State<MapLocationPickerScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedLatLng;
  String _address = "Fetching your current location...";
  final _places = GoogleMapsPlaces(
    apiKey: "AIzaSyC2JgccRMqweChAxeShHiLLaFnVLrPBe_I",
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });
  }

  /// ✅ Get live user location (for auto confirm)
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position =
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    LatLng currentLatLng = LatLng(position.latitude, position.longitude);
    setState(() {
      _selectedLatLng = currentLatLng;
    });

    await _updateAddressFromLatLng(currentLatLng);
  }

  /// ✅ Update address from tapped or detected coordinates
  Future<void> _updateAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _address =
          "${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}";
        });
      }
    } catch (e) {
      print("Error getting address: $e");
    }
  }

  /// ✅ User taps map
  Future<void> _onMapTap(LatLng latLng) async {
    setState(() => _selectedLatLng = latLng);
    await _updateAddressFromLatLng(latLng);
  }

  /// ✅ Search manually
  Future<void> _handleSearch() async {
    Prediction? prediction = await PlacesAutocomplete.show(
      context: context,
      apiKey: "AIzaSyC2JgccRMqweChAxeShHiLLaFnVLrPBe_I",
      mode: Mode.overlay,
      language: "en",
      components: [Component(Component.country, "pk")],
    );

    if (prediction != null) {
      final detail = await _places.getDetailsByPlaceId(prediction.placeId!);
      final location = detail.result.geometry!.location;

      setState(() {
        _selectedLatLng = LatLng(location.lat, location.lng);
        _address = detail.result.formattedAddress ?? "Unknown location";
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_selectedLatLng!, 15),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _selectedLatLng == null
            ? const Center(child: CircularProgressIndicator())
            : Stack(
          children: [
            /// 🗺 Map
            Positioned.fill(
              bottom: 80.h,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _selectedLatLng!,
                  zoom: 15,
                ),
                onMapCreated: (controller) => _mapController = controller,
                onTap: _onMapTap,
                markers: {
                  Marker(
                    markerId: const MarkerId("selected"),
                    position: _selectedLatLng!,
                  ),
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
              ),
            ),

            /// 🔍 Search bar
            Positioned(
              top: 10.h,
              left: 10.w,
              right: 10.w,
              child: GestureDetector(
                onTap: _handleSearch,
                child: Container(
                  height: 50.h,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _address,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// ✅ Confirm Button
            Positioned(
              bottom: 10.h,
              left: 20.w,
              right: 20.w,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (_selectedLatLng == null) return;

                  Navigator.pop(context, {
                    "address": _address,
                    "lat": _selectedLatLng!.latitude,
                    "lng": _selectedLatLng!.longitude,
                  });
                },
                child: const Text(
                  "Confirm Location",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
