import 'package:collabhub/widgets/bottom_nav.dart' show BottomNav;
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _chats = [
    {
      'name': 'Project Alpha Team',
      'lastMessage': 'Alex: I have updated the UI designs in Figma',
      'time': '10:30 AM',
      'unread': 3,
      'isGroup': true,
      'members': ['Alex', 'Jordan', 'Maya', 'You'],
    },
    {
      'name': 'David Osei',
      'lastMessage': 'Can you review the PR I sent?',
      'time': 'Yesterday',
      'unread': 0,
      'isGroup': false,
    },
    {
      'name': 'HealthTech App Group',
      'lastMessage': 'Meeting scheduled for tomorrow at 3 PM',
      'time': 'Yesterday',
      'unread': 1,
      'isGroup': true,
      'members': ['Morgan', 'Casey', 'You', '5 others'],
    },
    {
      'name': 'Sarah Mensah',
      'lastMessage': 'Thanks for your help with the documentation!',
      'time': 'Monday',
      'unread': 0,
      'isGroup': false,
    },
    {
      'name': 'E-commerce Platform',
      'lastMessage': 'You: I will work on the payment integration',
      'time': 'Monday',
      'unread': 0,
      'isGroup': true,
      'members': ['Dana', 'Jesse', 'Pat', 'You'],
    },
  ];

  // Tabs for different chat categories
  late TabController _tabController;

  // Track the selected navigation item
  final int _selectedIndex = 3; // Set to 3 since we're on the Chat tab

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Messages'),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).colorScheme.primary,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Groups'),
            Tab(text: 'Direct'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // All Chats Tab
          _buildChatList(_chats),

          // Groups Tab
          _buildChatList(
            _chats.where((chat) => chat['isGroup'] == true).toList(),
          ),

          // Direct Messages Tab
          _buildChatList(
            _chats.where((chat) => chat['isGroup'] == false).toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show new message dialog
          _showNewMessageDialog();
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _selectedIndex,
        parentContext: context,
      ),
    );
  }

  Widget _buildChatList(List<Map<String, dynamic>> chats) {
    return chats.isEmpty
        ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No conversations yet',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                'Start a new chat to collaborate',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
              ),
            ],
          ),
        )
        : ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];
            return Card(
              elevation: 0,
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: CircleAvatar(
                  backgroundColor:
                      chat['isGroup']
                          ? Colors.deepPurple.withOpacity(0.7)
                          : Colors.blue.withOpacity(0.7),
                  radius: 24,
                  child:
                      chat['isGroup']
                          ? const Icon(Icons.group, color: Colors.white)
                          : Text(
                            chat['name'].toString().substring(0, 1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        chat['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      chat['time'],
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            chat['unread'] > 0
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      chat['lastMessage'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color:
                            chat['unread'] > 0
                                ? Colors.black87
                                : Colors.grey[600],
                        fontWeight:
                            chat['unread'] > 0
                                ? FontWeight.w500
                                : FontWeight.normal,
                      ),
                    ),
                    if (chat['isGroup']) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.people, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            chat['members'].join(', '),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                trailing:
                    chat['unread'] > 0
                        ? Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            chat['unread'].toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                        : null,
                onTap: () {
                  // Navigate to chat detail screen
                  _navigateToChatDetail(chat);
                },
              ),
            );
          },
        );
  }

  void _navigateToChatDetail(Map<String, dynamic> chat) {
    // Sample message data for the mock chat interface
    final List<Map<String, dynamic>> _messages = [
      {
        'sender': 'Alex',
        'text': 'I have updated the UI designs in Figma',
        'time': '10:30 AM',
        'isMe': false,
      },
      {
        'sender': 'You',
        'text': 'Thanks! I will take a look at them',
        'time': '10:32 AM',
        'isMe': true,
      },
      {
        'sender': 'Maya',
        'text': 'The navigation flow looks much better now!',
        'time': '10:35 AM',
        'isMe': false,
      },
      {
        'sender': 'Jordan',
        'text': 'When can we start implementing these designs?',
        'time': '10:40 AM',
        'isMe': false,
      },
      {
        'sender': 'You',
        'text': 'I can start working on it this afternoon',
        'time': '10:42 AM',
        'isMe': true,
      },
    ];

    // Show a mock chat interface
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          final TextEditingController _chatMessageController =
              TextEditingController();

          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                        chat['isGroup']
                            ? Colors.deepPurple.withOpacity(0.7)
                            : Colors.blue.withOpacity(0.7),
                    radius: 16,
                    child:
                        chat['isGroup']
                            ? const Icon(
                              Icons.group,
                              color: Colors.white,
                              size: 16,
                            )
                            : Text(
                              chat['name'].toString().substring(0, 1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(chat['name'], style: const TextStyle(fontSize: 16)),
                      if (chat['isGroup'])
                        Text(
                          '${chat['members'].length} members',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[200],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.videocam_outlined),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () {},
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.grey[100],
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 20,
                      ),
                      itemCount: _messages.length,
                      reverse: false,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        final isMe = message['isMe'] as bool;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            mainAxisAlignment:
                                isMe
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isMe) ...[
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.blue[300],
                                  child: Text(
                                    message['sender'].toString().substring(
                                      0,
                                      1,
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isMe
                                            ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                            : Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (!isMe && chat['isGroup']) ...[
                                        Text(
                                          message['sender'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                isMe
                                                    ? Colors.white
                                                    : Colors.blue[700],
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                      ],
                                      Text(
                                        message['text'],
                                        style: TextStyle(
                                          color:
                                              isMe
                                                  ? Colors.white
                                                  : Colors.black87,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        message['time'],
                                        style: TextStyle(
                                          color:
                                              isMe
                                                  ? Colors.white.withOpacity(
                                                    0.7,
                                                  )
                                                  : Colors.grey[500],
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (isMe) const SizedBox(width: 8),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, -1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.attach_file),
                        color: Colors.grey[600],
                        onPressed: () {},
                      ),
                      Expanded(
                        child: TextField(
                          controller: _chatMessageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                          textCapitalization: TextCapitalization.sentences,
                          minLines: 1,
                          maxLines: 5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.send),
                          color: Colors.white,
                          onPressed: () {
                            if (_chatMessageController.text.trim().isNotEmpty) {
                              // In a real app, we would send the message here
                              _chatMessageController.clear();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showNewMessageDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            expand: false,
            builder: (context, scrollController) {
              final TextEditingController _searchController =
                  TextEditingController();

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'New Message',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search for people or groups',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.group_add,
                                size: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Create Group',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Suggested',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemCount: _chats.length,
                      itemBuilder: (context, index) {
                        final contact = _chats[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                contact['isGroup']
                                    ? Colors.deepPurple.withOpacity(0.7)
                                    : Colors.blue.withOpacity(0.7),
                            child:
                                contact['isGroup']
                                    ? const Icon(
                                      Icons.group,
                                      color: Colors.white,
                                    )
                                    : Text(
                                      contact['name'].toString().substring(
                                        0,
                                        1,
                                      ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                          ),
                          title: Text(
                            contact['name'],
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle:
                              contact['isGroup']
                                  ? Text('${contact['members'].length} members')
                                  : null,
                          onTap: () {
                            Navigator.pop(context);
                            _navigateToChatDetail(contact);
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }
}
