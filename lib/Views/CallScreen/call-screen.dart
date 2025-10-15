import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // for date formatting
import '../../Constants/colors.dart';

class UserCallScreen extends StatelessWidget {
  const UserCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.logocolor,
          title: const Text("Calls"),
        ),
        body: const Center(child: Text("Not logged in")),
      );
    }
    final currentUserId = currentUser.uid;

    // NOTE: we do NOT use orderBy here to avoid composite-index errors.
    final Stream<QuerySnapshot> callsStream = FirebaseFirestore.instance
        .collection('calls')
        .where('participants', arrayContains: currentUserId)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.logocolor,

        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Calls",
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: callsStream,
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state — show the real error so you can debug (index error, permissions, etc.)
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error loading calls:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          // No data / empty
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No call history",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          }

          // Convert docs to a list and sort by timestamp (descending) on client side
          final docs = List<QueryDocumentSnapshot>.from(snapshot.data!.docs);

          docs.sort((a, b) {
            final aData = (a.data() as Map<String, dynamic>?) ?? {};
            final bData = (b.data() as Map<String, dynamic>?) ?? {};

            final aTs = aData['timestamp'] as Timestamp?;
            final bTs = bData['timestamp'] as Timestamp?;

            final aDate = aTs?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0);
            final bDate = bTs?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0);

            // descending: newest first
            return bDate.compareTo(aDate);
          });

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final call = (doc.data() as Map<String, dynamic>?) ?? {};

              final bool isCaller = (call['callerId'] ?? '') == currentUserId;
              final String otherUserName = isCaller
                  ? (call['receiverName'] ?? 'Unknown')
                  : (call['callerName'] ?? 'Unknown');
              final String otherUserImage = isCaller
                  ? (call['receiverImage'] ?? '')
                  : (call['callerImage'] ?? '');
              final bool isIncoming = !isCaller;

              // Format timestamp safely
              String formattedTime = '';
              if (call['timestamp'] != null && call['timestamp'] is Timestamp) {
                try {
                  final DateTime date = (call['timestamp'] as Timestamp).toDate();
                  formattedTime = DateFormat("MMM d, h:mm a").format(date);
                } catch (_) {
                  formattedTime = '';
                }
              }

              return Dismissible(
                key: Key(doc.id),
                direction: DismissDirection.endToStart,
                onDismissed: (_) async {
                  try {
                    await FirebaseFirestore.instance.collection('calls').doc(doc.id).delete();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Call deleted')));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
                  }
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
        radius: 25,
        backgroundColor: Colors.grey.shade300,
        child: ClipOval(
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: 50,
            height: 50,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child; // ✅ image loaded
              return const Center(
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ); // 👈 show loader until image appears
            },
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.person, color: Colors.white, size: 26);
            },
          ),
        ),
      ),

        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Row(
        children: [
          Icon(isIncoming ? Icons.call_received : Icons.call_made,
              size: 16, color: isIncoming ? Colors.green : Colors.red),
          const SizedBox(width: 6),
          Text(time, style: const TextStyle(color: Colors.black54, fontSize: 13)),
        ],
      ),
      trailing: Icon(Icons.call, color: AppColors.logocolor),
    );
  }
}
