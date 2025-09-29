import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // ✅ for date formatting
import '../../Constants/colors.dart';

class UserCallScreen extends StatelessWidget {
  const UserCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.logocolor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Calls",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),


      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("calls")
            .where("participants", arrayContains: currentUserId) // ✅ show only user's calls
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text("No call history"));
          }

          var callLogs = snapshot.data!.docs;

          if (callLogs.isEmpty) {
            return const Center(child: Text("No call history"));
          }

          return ListView.builder(
            itemCount: callLogs.length,
            itemBuilder: (context, index) {
              var call = callLogs[index].data() as Map<String, dynamic>;

              bool isCaller = call["callerId"] == currentUserId;
              String otherUserName =
              isCaller ? call["receiverName"] ?? "Unknown" : call["callerName"] ?? "Unknown";
              String otherUserImage =
              isCaller ? (call["receiverImage"] ?? "") : (call["callerImage"] ?? "");
              bool isIncoming = !isCaller;

              // ✅ Format timestamp
              String formattedTime = "";
              if (call["timestamp"] != null) {
                DateTime date = (call["timestamp"] as Timestamp).toDate();
                formattedTime = DateFormat("MMM d, h:mm a").format(date);
              }

              return Dismissible(
                key: Key(callLogs[index].id),
                direction: DismissDirection.endToStart,
                onDismissed: (_) async {
                  await FirebaseFirestore.instance
                      .collection("calls")
                      .doc(callLogs[index].id)
                      .delete();
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: CallTile(
                  name: otherUserName,
                  imageUrl: otherUserImage,
                  time: formattedTime,
                  isIncoming: isIncoming,
                ),
              );
            },
          );
        },
      ),

    );
  }
}

class CallTile extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String time;
  final bool isIncoming;

  const CallTile({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.time,
    required this.isIncoming,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: imageUrl.isNotEmpty
            ? NetworkImage(imageUrl)
            : const AssetImage("assets/images/default_avatar.png") as ImageProvider,
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Row(
        children: [
          Icon(
            isIncoming ? Icons.call_received : Icons.call_made,
            size: 16,
            color: isIncoming ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 6),
          Text(
            time,
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
        ],
      ),
      trailing: Icon(Icons.call, color: AppColors.logocolor),
    );
  }
}
