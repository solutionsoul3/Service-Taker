import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/UserModel.dart';

class UserController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _cachedUser; // ✅ cache to make it instant next time

  /// Fetch current user details (fast with cache + Firestore listener)
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      // ✅ Return cached user if already loaded
      if (_cachedUser != null) return _cachedUser;

      final doc = await _firestore.collection("User").doc(user.uid).get();

      if (!doc.exists) return null;

      _cachedUser = UserModel.fromDocument(doc); // store in cache
      return _cachedUser;
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

  /// ✅ Real-time user stream (instant updates without delay)
  Stream<UserModel?> streamCurrentUser() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore.collection("User").doc(user.uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      final userModel = UserModel.fromDocument(doc);
      _cachedUser = userModel; // update cache too
      return userModel;
    });
  }
}
