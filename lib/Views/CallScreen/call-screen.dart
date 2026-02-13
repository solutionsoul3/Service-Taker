import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Constants/colors.dart';

class UserCallScreen extends StatelessWidget {
  const UserCallScreen({super.key});

  Future<void> _deleteAllLogs(String userId) async {
    final callLogsRef = FirebaseFirestore.instance
        .collection("User")
        .doc(userId)
        .collection("calls");

    final snapshot = await callLogsRef.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> _makeCall(BuildContext context, Map<String, dynamic> call) async {
    // Get the contact number depending on incoming/outgoing type
    final String contactNumber = call['receiverContactNumber'] ??
        call['callerPhoneNumber'] ??
        "N/A";

    if (contactNumber == "N/A" || contactNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No contact number available")),
      );
      return;
    }

    final Uri callUri = Uri.parse("tel:$contactNumber");

    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not launch dialer")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Center(child: Text("Not logged in"));
    }

    final userId = currentUser.uid;
    final callLogsStream = FirebaseFirestore.instance
        .collection("User")
        .doc(userId)
        .collection("calls")
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.logocolor,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(50),
              child: Container(
                height: 35,
                width: 35,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back_ios_rounded,
                    color: AppColors.logocolor, size: 20),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "Calls",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: InkWell(
              onTap: () async {
                await _deleteAllLogs(userId);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("All call logs deleted")),
                );
              },
              borderRadius: BorderRadius.circular(50),
              child: Container(
                height: 35,
                width: 35,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete, color: Colors.red, size: 20),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: callLogsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No call history"));
          }

          final docs = snapshot.data!.docs;
          docs.sort((a, b) {
            final aTime =
                (a['timestamp'] as Timestamp?)?.toDate() ?? DateTime(0);
            final bTime =
                (b['timestamp'] as Timestamp?)?.toDate() ?? DateTime(0);
            return bTime.compareTo(aTime);
          });

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final call = docs[index].data() as Map<String, dynamic>;
              final isIncoming = (call['type'] ?? '') == "incoming";

              String formattedTime = "";
              if (call['timestamp'] != null) {
                final date = (call['timestamp'] as Timestamp).toDate();
                formattedTime = DateFormat("MMM d, h:mm a").format(date);
              }

              return Dismissible(
                key: Key(docs[index].id),
                direction: DismissDirection.endToStart,
                onDismissed: (_) async {
                  await docs[index].reference.delete();
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      isIncoming
                          ? (call['callerImage'] ?? "")
                          : (call['receiverImage'] ?? ""),
                    ),
                    radius: 25,
                  ),
                  title: Text(
                    isIncoming
                        ? (call['callerName'] ?? "Unknown")
                        : (call['receiverName'] ?? "Unknown"),
                  ),
                  subtitle: Row(
                    children: [
                      Icon(
                        isIncoming ? Icons.call_received : Icons.call_made,
                        size: 16,
                        color: isIncoming ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 6),
                      Text(formattedTime),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.call, color: Colors.green),
                    onPressed: () => _makeCall(context, call),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
