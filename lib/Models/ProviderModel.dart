class Availability {
  final String day;
  final String startTime;
  final String endTime;

  Availability({
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  factory Availability.fromMap(Map<String, dynamic> data) {
    return Availability(
      day: data['day'] ?? '',
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Availability(day: $day, startTime: $startTime, endTime: $endTime)';
  }
}

class ProviderModel {
  String id;
  String fullName;
  String description;
  String email;
  String contactNumber;
  String experience;
  String experienceDescription;
  bool formFilled;
  String imageUrl;
  String location;
  double pricePerHour;
  String service;
  String status;
  String uid;
  List<Availability> availability;

  // ✅ Added fields
  double latitude;
  double longitude;

  ProviderModel({
    this.id = '',
    this.fullName = '',
    this.description = '',
    this.email = '',
    this.contactNumber = '',
    this.experience = '',
    this.experienceDescription = '',
    this.formFilled = false,
    this.imageUrl = '',
    this.location = '',
    this.pricePerHour = 0.0,
    this.service = '',
    this.status = '',
    this.uid = '',
    this.availability = const [],
    this.latitude = 0.0, // default 0.0
    this.longitude = 0.0, // default 0.0
  });

  factory ProviderModel.fromMap(Map<String, dynamic> data, String documentId) {
    print('Mapping data for document: $documentId');
    print('Raw data: $data');

    List<Availability> availabilityList =
    (data['availability'] as List<dynamic>? ?? [])
        .map((item) => Availability.fromMap(item))
        .toList();

    return ProviderModel(
      id: documentId,
      fullName: data['fullName'] ?? 'Unknown Provider',
      description: data['description'] ?? 'No description available.',
      email: data['email'] ?? 'No email provided',
      contactNumber: data['contactNumber'] ?? 'No contact number provided',
      experience: data['experience'] ?? 'Not specified',
      experienceDescription: data['experienceDescription'] ?? 'No description.',
      formFilled: data['formFilled'] ?? false,
      imageUrl: data['imageUrl'] ?? '',
      location: data['location'] ?? 'Unknown Location',
      pricePerHour: (data['pricePerHour'] != null)
          ? double.tryParse(data['pricePerHour'].toString()) ?? 0.0
          : 0.0,
      service: data['service'] ?? 'Not specified',
      status: data['status'] ?? 'Inactive',
      uid: data['uid'] ?? '',
      availability: availabilityList,

      // ✅ Added mapping for coordinates
      latitude: (data['latitude'] != null)
          ? double.tryParse(data['latitude'].toString()) ?? 0.0
          : 0.0,
      longitude: (data['longitude'] != null)
          ? double.tryParse(data['longitude'].toString()) ?? 0.0
          : 0.0,
    );
  }

  @override
  String toString() {
    return 'ProviderModel(id: $id, fullName: $fullName, description: $description, email: $email, contactNumber: $contactNumber, experience: $experience, experienceDescription: $experienceDescription, formFilled: $formFilled, imageUrl: $imageUrl, location: $location, pricePerHour: $pricePerHour, service: $service, status: $status, uid: $uid, latitude: $latitude, longitude: $longitude, availability: $availability)';
  }
}
