import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/Models/ProviderModel.dart';
import 'package:talk/constants/colors.dart';
import 'package:talk/widgets/customcontainer.dart';

import '../../utility/custom-intl.dart';

class ChatWithUser extends StatefulWidget {
  final ProviderModel provider;
  const ChatWithUser({
    super.key,
    required this.provider,
  });

  @override
  _ChatWithUserState createState() => _ChatWithUserState();
}

class _ChatWithUserState extends State<ChatWithUser> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages =
      []; // List to hold chat messages and timestamps

  void _sendMessage() {
    final message = _messageController.text;
    if (message.isNotEmpty) {
      final timestamp = DateTime.now(); // Use DateTime object for sorting
      final formattedDate = DateFormatter.formatReadableDate(timestamp);
      final formattedTime = DateFormatter.formatTime12h(timestamp);

      setState(() {
        _messages.insert(0, {
          'message': message,
          'timestamp': formattedTime,
          'date': formattedDate,
        });
      });

      _messageController.clear(); // Clear the text field
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
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 24.sp,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Navigate back to the previous screen
              },
            ),
            GestureDetector(
              onTap: () => _showAvatarDialog(context),
              child: CircleAvatar(
                radius: 16.r,
                backgroundImage: NetworkImage(widget.provider.imageUrl),
              ),
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
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final messageData = _messages[index];
                final message = messageData['message'];
                final timestamp = messageData['timestamp'];
                final date = messageData['date'];
                return Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 5.h), // Height between messages
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: 250.w,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.logocolor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.all(8.w), // Add padding for content
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.provider.fullName,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Urbanist',
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                CircleAvatar(
                                  radius: 16.r,
                                  backgroundImage:
                                      NetworkImage(widget.provider.imageUrl),
                                ),
                              ],
                            ),
                            SizedBox(
                                height: 4
                                    .h), // Adjust space between name/avatar and message
                            Text(
                              message,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: 4.h), // Space between message and date/time
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            date,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Urbanist',
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            timestamp,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Urbanist',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          CustomContainer(
            height: 50.h,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    color: AppColors.logocolor,
                  ),
                  onPressed: () {
                    // Add your camera action here
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.photo,
                    color: AppColors.logocolor,
                  ),
                  onPressed: () {
                    // Add your photo action here
                  },
                ),
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
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: AppColors.logocolor,
                  ),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
