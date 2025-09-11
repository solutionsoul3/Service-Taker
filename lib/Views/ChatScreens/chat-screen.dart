import 'package:flutter/material.dart';
import '../../Constants/colors.dart';
import 'chat-with-user.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Dummy chat list
  List<Map<String, dynamic>> chats = [
    {
      "name": "Iqra ️",
      "message": "Hey,Bro What's up",
      "time": "09/12/23",
      "isRead": true,
      "isVoice": false,
      "isPhoto": false
    },
    {
      "name": "John Smith",
      "message": "Hi there are you avaiable ",
      "time": "09/12/23",
      "isRead": true,
      "isVoice": false,
      "isPhoto": false
    },
    {
      "name": "Anthony",
      "message": "0:14",
      "time": "09/12/23",
      "isRead": false,
      "isVoice": true,
      "isPhoto": false
    },
    {
      "name": "Jasim ",
      "message": "Are you Avialable",
      "time": "09/12/23",
      "isRead": true,
      "isVoice": false,
      "isPhoto": false
    },
    {
      "name": "Saad",
      "message": "Photo",
      "time": "09/10/23",
      "isRead": false,
      "isVoice": false,
      "isPhoto": true
    },
    {
      "name": "Saqlain",
      "message":
      "Actually I wanted to check with you about ",
      "time": "09/10/23",
      "isRead": false,
      "isVoice": false,
      "isPhoto": false
    },

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.logocolor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Chats",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.edit, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          // Broadcast Lists + New Group row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Broadcast Lists",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                Text(
                  "New Chats",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),

          // Chats List
          Expanded(
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return
                  ListTile(

                    title: Text(
                      chat["name"],
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    subtitle: Row(
                      children: [
                        if (chat["isVoice"])
                          const Icon(Icons.mic, size: 16, color: Colors.green),
                        if (chat["isRead"])
                          const Icon(Icons.done_all, size: 16, color: Colors.blue),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            chat["message"],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      chat["time"],
                      style: const TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatDetailScreen(
                            name: chat["name"],
                            profileUrl: "assets/images/profile.png",
                          ),
                        ),
                      );
                    },
                  );

              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.logocolor,
        onPressed: () {

        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}
