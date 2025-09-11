import 'package:flutter/material.dart';

import '../../Constants/colors.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  // Dummy call logs
  List<Map<String, dynamic>> callLogs = [
    {"name": "Adam Kain", "time": "35 minutes ago", "incoming": true, "count": 2},
    {"name": "Roberto & Thais", "time": "Today, 9:16", "incoming": true, "count": 1},
    {"name": "Sujay Nassar", "time": "Yesterday, 16:00", "incoming": false, "count": 2},
    {"name": "Adele Benton", "time": "9 December, 12:51", "incoming": true, "count": 1},
    {"name": "Scott Brown", "time": "7 December, 11:01", "incoming": false, "count": 1},
    {"name": "Scarlett Coupe", "time": "7 December, 10:27", "incoming": true, "count": 1},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Calls",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.logocolor,
        actions: const [
          Icon(Icons.search,color: Colors.white,),
          SizedBox(width: 16),
          Icon(Icons.more_vert,color: Colors.white,),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // "Create call link" option
          ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.logocolor,
              child: const Icon(Icons.link, color: Colors.white),
            ),
            title: const Text("Create call link"),
            subtitle: const Text("Share a link for your WhatsApp call"),
          ),

          // Recent calls list with swipe to delete
          Expanded(
            child: ListView.builder(
              itemCount: callLogs.length,
              itemBuilder: (context, index) {
                final call = callLogs[index];
                return Dismissible(
                  key: Key(call["name"] + call["time"]),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      callLogs.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${call["name"]} deleted")),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: CallTile(
                    name: call["name"],
                    time: call["time"],
                    isIncoming: call["incoming"],
                    callCount: call["count"],
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.logocolor,
        onPressed: () {
          // Add new call logic
        },
        child: const Icon(Icons.add_call),
      ),
    );
  }
}

class CallTile extends StatelessWidget {
  final String name;
  final String time;
  final bool isIncoming;
  final int callCount;

  const CallTile({
    super.key,
    required this.name,
    required this.time,
    required this.isIncoming,
    this.callCount = 1,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Removed avatar for a modern clean look
      title: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
      subtitle: Row(
        children: [
          Icon(
            isIncoming ? Icons.call_received : Icons.call_made,
            size: 16,
            color: isIncoming ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 6),
          Text(
            callCount > 1 ? "($callCount) $time" : time,
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
        ],
      ),
      trailing: Icon(
        Icons.call, // Always audio call
        color: AppColors.logocolor,
      ),
    );
  }
}
