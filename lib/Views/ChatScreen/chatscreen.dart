import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../Constants/colors.dart';
import '../../Models/ProviderModel.dart';
import 'chat_with_provider.dart';

class ChatScreen extends StatelessWidget {
  final bool isProvider; // true if current user is a provider
  const ChatScreen({super.key, this.isProvider = false});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final collection = isProvider ? "Provider" : "User";

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
            .collection(collection)
            .doc(currentUserId)
            .collection("chats")
            .orderBy("lastMessageTime", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final rooms = snapshot.data!.docs;
          if (rooms.isEmpty) {
            return const Center(child: Text("No chats yet"));
          }

          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index].data() as Map<String, dynamic>?;

              if (room == null) return const SizedBox();

              final participants = (room["participants"] as List<dynamic>?) ?? [];
              if (participants.isEmpty) return const SizedBox();

              // Get the other participant safely
              final receiverId = participants.firstWhere(
                    (id) => id != currentUserId,
                orElse: () => null,
              );

              if (receiverId == null) return const SizedBox();

              final names = room["names"] as Map<String, dynamic>? ?? {};
              final images = room["images"] as Map<String, dynamic>? ?? {};

              final receiverName = names[receiverId] ?? "Unknown";
              final receiverImage = images[receiverId] ?? "https://via.placeholder.com/150";

              final provider = ProviderModel(
                id: receiverId,
                fullName: receiverName,
                imageUrl: receiverImage,
              );

              final lastMessage = room["lastMessage"] ?? "";
              final lastTime = room["lastMessageTime"] != null
                  ? (room["lastMessageTime"] is Timestamp
                  ? (room["lastMessageTime"] as Timestamp).toDate()
                  : DateTime.tryParse(room["lastMessageTime"].toString()))
                  : null;

              final timeText = lastTime != null
                  ? "${lastTime.year}-${lastTime.month.toString().padLeft(2,'0')}-${lastTime.day.toString().padLeft(2,'0')}"
                  : "";

              return ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: receiverImage.isNotEmpty
                      ? NetworkImage(receiverImage)
                      : null,
                  child: receiverImage.isEmpty
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),
                title: Text(receiverName, style: TextStyle(color: AppColors.logocolor)),
                subtitle: Text(lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: Text(timeText, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
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
