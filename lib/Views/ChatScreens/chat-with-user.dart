import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Constants/colors.dart';

class ChatDetailScreen extends StatefulWidget {
  final String name;
  final String profileUrl;

  const ChatDetailScreen({
    super.key,
    required this.name,
    this.profileUrl = "assets/images/profile.png",
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();

  // Dummy messages
  List<Map<String, dynamic>> messages = [
    {"text": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit", "time": "5:20 PM", "isMe": true},
    {"text": "Consectetuer elit", "time": "5:18 PM", "isMe": false},
    {"text": "Sit arnet", "time": "5:20 PM", "isMe": true},
    {"text": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit", "time": "5:18 PM", "isMe": false},
    {"text": "Adipiscing amet", "time": "5:22 PM", "isMe": false},
    {"text": "Ipsum dolor sit amet, consectetuer adipiscing elit lorem sit", "time": "5:18 PM", "isMe": false},
    {"text": "Consectetuer", "time": "5:20 PM", "isMe": true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffECE5DD),
      appBar: AppBar(
        backgroundColor: AppColors.logocolor,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.white), // <-- icons white
        title: Row(
          children: [
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: GoogleFonts.poppins( // <-- good font
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: const [
          Icon(Icons.call, color: Colors.white),
          SizedBox(width: 16),
          Icon(Icons.more_vert, color: Colors.white),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final bool isMe = msg["isMe"];

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? AppColors.logocolor : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: isMe ? const Radius.circular(12) : const Radius.circular(0),
                        bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          msg["text"],
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: isMe ? Colors.white : Colors.black, // <-- text color
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              msg["time"],
                              style: TextStyle(
                                fontSize: 11,
                                color: isMe ? Colors.white70 : Colors.black54,
                              ),
                            ),
                            if (isMe) ...[
                              const SizedBox(width: 4),
                              const Icon(Icons.done_all, size: 16, color: Colors.white),
                            ]
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Message Input Box
          SafeArea(
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30), // <-- rounded input row
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: "Type a message",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.attach_file, color: Colors.grey),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.grey),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
