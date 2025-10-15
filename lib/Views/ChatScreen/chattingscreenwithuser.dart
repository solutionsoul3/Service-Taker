import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:talk/Models/ProviderModel.dart';
import 'package:talk/constants/colors.dart';
import 'package:talk/widgets/customcontainer.dart';

import '../../Controller/chat-controller.dart';

class ChatWithProvider extends StatefulWidget {
  final ProviderModel provider;
  const ChatWithProvider({super.key, required this.provider});

  @override
  _ChatWithProviderState createState() => _ChatWithProviderState();
}

class _ChatWithProviderState extends State<ChatWithProvider> {
  final ChatController chatController = Get.put(ChatController());
  final TextEditingController _messageController = TextEditingController();
  late String currentUserId;
  String currentUserName = "User";
  String currentUserImage = "https://via.placeholder.com/150";

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUserId = user.uid;

      // Fetch Firestore fields for name and image
      FirebaseFirestore.instance.collection("User").doc(currentUserId).get().then((doc) {
        if (doc.exists) {
          setState(() {
            currentUserName = doc.data()?["name"] ?? "User";
            currentUserImage = doc.data()?["imageUrl"] ?? "https://via.placeholder.com/150";
          });
        }
      });

      chatController.initChat(currentUserId, widget.provider.id);
    }
  }

  void _showAvatarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 300.w,
            height: 300.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.provider.imageUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.logocolor,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 24.sp),
              onPressed: () => Navigator.of(context).pop(),
            ),
            GestureDetector(
              onTap: () => _showAvatarDialog(context),
              child: CircleAvatar(
                radius: 16.r,
                backgroundColor: Colors.grey.shade300, // gray background
                backgroundImage: (widget.provider.imageUrl.isNotEmpty)
                    ? NetworkImage(widget.provider.imageUrl)
                    : null,
                child: (widget.provider.imageUrl.isEmpty)
                    ? const Icon(Icons.person, color: Colors.white, size: 20)
                    : null,
              )

            ),
            SizedBox(width: 10.w),
            Text(
              widget.provider.fullName,
              style: TextStyle(
                fontSize: 18.sp,
                fontFamily: 'Urbanist',
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // Messages list
          Expanded(
            child: Obx(() {
              final msgs = chatController.messages;

              if (msgs.isEmpty) {
                return Center(
                  child: Text(
                    "No messages yet",
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                reverse: true,
                itemCount: msgs.length,
                itemBuilder: (context, index) {
                  final message = msgs[index];
                  final isMe = message.senderId == currentUserId;

                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: isMe ? AppColors.logocolor : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        message.text,
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black,
                          fontSize: 14.sp,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          // Input box
          CustomContainer(
            height: 50.h,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message',
                      hintStyle: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Urbanist',
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: AppColors.logocolor),
                  onPressed: () async {
                    final text = _messageController.text.trim();
                    if (text.isEmpty) return;

                    // ✅ Clear the text field immediately
                    _messageController.clear();

                    // ✅ Then send the message in background
                    await chatController.sendMessage(
                      text: text,
                      senderId: currentUserId,
                      receiverId: widget.provider.id,
                      senderName: currentUserName,
                      senderImage: currentUserImage,
                      receiverName: widget.provider.fullName,
                      receiverImage: widget.provider.imageUrl,
                    );
                  },
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
