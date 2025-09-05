import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
   final String? bio; 
  final String phoneNumber;
  final String? imageUrl;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.bio, 
    required this.phoneNumber,
    this.imageUrl,
  });

  // Factory method to create a UserModel from Firestore data
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: data['uid'],
      name: data['name'],
         bio: data['bio'],  
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      imageUrl: data['imageUrl'],
    );
  }
}
