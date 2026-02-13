import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/ProviderModel.dart';

class ProviderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ProviderModel>> fetchProviders() async {
    try {
      final snapshot = await _firestore.collection('Provider').get();

      return snapshot.docs.map((doc) {
        return ProviderModel.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching providers: $e");
      return [];
    }
  }
}
