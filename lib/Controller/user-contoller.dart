import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/UserModel.dart';

class UserController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch current user details from Firestore
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc =
      await _firestore.collection("User").doc(user.uid).get();

      if (!doc.exists) return null;

      return UserModel.fromDocument(doc);
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }
}
