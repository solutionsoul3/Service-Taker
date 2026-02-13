import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> logCall({
  required String callerId,
  required String callerName,
  required String callerImage,
  required String callerPhoneNumber,
  required String receiverId,
  required String receiverName,
  required String receiverImage,
  required String receiverPhoneNumber,
}) async {
  final timestamp = FieldValue.serverTimestamp();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // ✅ Save for Caller (User or Provider)
  await firestore
      .collection("User")
      .doc(callerId)
      .collection("calls")
      .add({
    "callerId": callerId,
    "callerName": callerName,
    "callerImage": callerImage,
    "callerContactNumber": callerPhoneNumber,
    "receiverId": receiverId,
    "receiverName": receiverName,
    "receiverImage": receiverImage,
    "receiverContactNumber": receiverPhoneNumber,
    "type": "outgoing",
    "timestamp": timestamp,
  });

  // ✅ Save for Receiver (Provider or User)
  await firestore
      .collection("Provider")
      .doc(receiverId)
      .collection("calls")
      .add({
    "callerId": callerId,
    "callerName": callerName,
    "callerImage": callerImage,
    "callerContactNumber": callerPhoneNumber,
    "receiverId": receiverId,
    "receiverName": receiverName,
    "receiverImage": receiverImage,
    "receiverContactNumber": receiverPhoneNumber,
    "type": "incoming",
    "timestamp": timestamp,
  });
}
