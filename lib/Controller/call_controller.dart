// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import '../models/call_model.dart';
//
// class CallController extends GetxController {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance; // ✅ define firestore here
//
//   var calls = <CallModel>[].obs;
//   var isLoading = true.obs; // track loading state
//
//   /// ✅ Listen to calls for current user
//   void listenToCalls(String currentUserId) {
//     isLoading.value = true;
//     firestore
//         .collection("calls")
//         .where("participants", arrayContains: currentUserId)
//         .orderBy("timestamp", descending: true)
//         .snapshots()
//         .listen((snapshot) {
//       calls.value = snapshot.docs.map((doc) {
//         return CallModel.fromMap(doc.data() as Map<String, dynamic>);
//       }).toList();
//
//       isLoading.value = false; // stop loading once data comes
//     });
//   }
//
//   /// ✅ Delete all calls for current user
//   Future<void> deleteAllCalls(String userId) async {
//     try {
//       final snapshot = await firestore
//           .collection("calls")
//           .where("participants", arrayContains: userId)
//           .get();
//
//       for (var doc in snapshot.docs) {
//         await doc.reference.delete();
//       }
//
//       calls.clear(); // clear local list immediately
//     } catch (e) {
//       print("Error deleting calls: $e");
//     }
//   }
//
//   /// ✅ Start a new call and save correct caller/receiver info
//   Future<void> startCall({
//     required String receiverId,
//   }) async {
//     final currentUser = FirebaseAuth.instance.currentUser!;
//     final callerData = await _getProfileData(currentUser.uid);
//     final receiverData = await _getProfileData(receiverId);
//
//     await firestore.collection("calls").add({
//       "callerId": currentUser.uid,
//       "callerName": callerData["name"],
//       "callerImage": callerData["imageUrl"],
//       "receiverId": receiverId,
//       "receiverName": receiverData["name"],
//       "receiverImage": receiverData["imageUrl"],
//       "participants": [currentUser.uid, receiverId],
//       "timestamp": FieldValue.serverTimestamp(),
//     });
//   }
//
//   /// ✅ Fetch profile from User or Provider collection
//   Future<Map<String, dynamic>> _getProfileData(String uid) async {
//     // First check User collection
//     var userDoc = await firestore.collection("User").doc(uid).get();
//     if (userDoc.exists) {
//       final data = userDoc.data()!;
//       return {
//         "name": data["name"] ?? "Unknown User",
//         "imageUrl": data["imageUrl"] ?? "",
//       };
//     }
//
//     // Then check Provider collection
//     var providerDoc = await firestore.collection("Provider").doc(uid).get();
//     if (providerDoc.exists) {
//       final data = providerDoc.data()!;
//       return {
//         "name": data["fullName"] ?? "Unknown Provider",
//         "imageUrl": data["imageUrl"] ?? "",
//       };
//     }
//
//     return {"name": "Unknown", "imageUrl": ""};
//   }
//
// }
