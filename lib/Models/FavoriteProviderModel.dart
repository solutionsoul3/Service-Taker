class FavoriteItemModel {
  final String providerId;
  final String providerName;
  final String imageUrl;
  final String service;
  final double rating;
  final double price;

  FavoriteItemModel({
    required this.providerId,
    required this.providerName,
    required this.imageUrl,
    required this.service,
    required this.rating,
    required this.price,
  });

  // Factory method to create an instance from Firestore data
  factory FavoriteItemModel.fromMap(Map<String, dynamic> data) {
    return FavoriteItemModel(
      providerId: data['providerId'] ?? '',
      providerName: data['providerName'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      service: data['service'] ?? '',
      // Safely convert rating to double, whether it's stored as a string or a number
      rating: (data['rating'] is String)
          ? double.tryParse(data['rating']) ?? 0.0
          : (data['rating'] ?? 0.0).toDouble(),
      // Same for price, ensure it's treated as double
      price: (data['price'] is String)
          ? double.tryParse(data['price']) ?? 0.0
          : (data['price'] ?? 0.0).toDouble(),
    );
  }
}
