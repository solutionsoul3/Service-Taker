import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/Models/ProviderModel.dart';
import 'package:talk/constants/colors.dart';

import '../../Views/ChatScreen/chattingscreenwithuser.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.logocolor,
        elevation: 0,

        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Chats',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Urbanist',
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),

      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("chat_rooms")
            .where("participants", arrayContains: currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var rooms = snapshot.data!.docs;

          if (rooms.isEmpty) {
            return const Center(child: Text("No chats yet"));
          }

          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              var room = rooms[index].data() as Map<String, dynamic>;

              // ✅ Get other participant
              List participants = room["participants"];
              String receiverId = participants.firstWhere((id) => id != currentUserId);

              String userName = room["names"]?[receiverId] ?? "Unknown";
              String userImage = room["images"]?[receiverId] ?? "https://via.placeholder.com/150";

              // ✅ Create ProviderModel object to pass
              final provider = ProviderModel(
                id: receiverId,
                fullName: userName,
                imageUrl: userImage,
              );

              return ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey,
                  child: ClipOval(
                    child: userImage.isNotEmpty
                        ? Image.network(
                      userImage,
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 26,
                      ),
                    )
                        : const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
                title: Text(userName, style: TextStyle(color: AppColors.logocolor)),
                subtitle: Text(room["lastMessage"] ?? ""),
                trailing: Text(
                  room["lastMessageTime"] != null
                      ? (room["lastMessageTime"] is Timestamp
                      ? (room["lastMessageTime"] as Timestamp)
                      .toDate()
                      .toString()
                      .substring(0, 10)
                      : room["lastMessageTime"].toString().substring(0, 10))
                      : "",
                  style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatWithProvider(provider: provider),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
