import 'package:flutter/material.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> chats = [
      {'name': 'Rahman', 'message': 'Last message preview...'},
      {'name': 'David', 'message': 'Last message preview...'},
      {'name': 'Pascal', 'message': 'Last message preview...'},
      {'name': 'Eugene', 'message': 'Last message preview...'},
      {'name': 'Sampah', 'message': 'Last message preview...'},
      {'name': 'Robert', 'message': 'Last message preview...'},
      {'name': '2025 Janvier', 'message': 'Last message preview...'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat List'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search chats...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Chat list
            Expanded(
              child: ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple[100],
                        child: Text(
                          chat['name']![0], // First letter of the name
                          style: const TextStyle(color: Colors.deepPurple),
                        ),
                      ),
                      title: Text(
                        chat['name']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(chat['message']!),
                      onTap: () {
                        // Navigate to chat details (to be implemented)
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
