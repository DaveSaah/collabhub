import 'package:collabhub/widgets/bottom_nav.dart' show BottomNav;
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class ThoughtBoardScreen extends StatefulWidget {
  const ThoughtBoardScreen({super.key});

  @override
  State<ThoughtBoardScreen> createState() => _ThoughtBoardScreenState();
}

class _ThoughtBoardScreenState extends State<ThoughtBoardScreen> {
  final TextEditingController _thoughtController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  DateTime? _lastShakeTime;
  bool _isComposing = false;

  // Firebase instances
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Stream<QuerySnapshot> _thoughtsStream;

  // Shake detection variables
  static const double _shakeThreshold = 100.0;

  // Track the selected navigation item
  final int _selectedIndex = 3; // Set to 3 to match the original chat position

  @override
  void initState() {
    super.initState();
    _initAccelerometer();

    // Initialize thoughts stream from Firestore
    _thoughtsStream =
        _firestore
            .collection('thoughts')
            .orderBy('timestamp', descending: true)
            .snapshots();
  }

  void _initAccelerometer() {
    // Set up accelerometer for shake detection
    _accelerometerSubscription = accelerometerEvents.listen((
      AccelerometerEvent event,
    ) {
      double acceleration = _calculateAcceleration(event);
      DateTime now = DateTime.now();

      // Check if this is a shake and not just normal movement
      if (acceleration > _shakeThreshold) {
        // Prevent multiple triggers for the same shake
        if (_lastShakeTime == null ||
            now.difference(_lastShakeTime!).inMilliseconds > 1000) {
          _lastShakeTime = now;
          _handleShake();
        }
      }
    });
  }

  double _calculateAcceleration(AccelerometerEvent event) {
    // Calculate the overall acceleration magnitude
    return (event.x * event.x + event.y * event.y + event.z * event.z);
  }

  void _handleShake() {
    // Only clear if the user is currently typing something
    if (_isComposing && _thoughtController.text.isNotEmpty) {
      setState(() {
        _thoughtController.clear();
        _isComposing = false;
      });
    }
  }

  Future<void> _addThought(String text) async {
    if (text.trim().isEmpty) return;

    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You need to be logged in to share thoughts'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      await _firestore.collection('thoughts').add({
        'text': text,
        'authorId': user.uid,
        'authorName': user.displayName ?? 'Anonymous',
        'timestamp': FieldValue.serverTimestamp(),
        'likes': 0,
      });

      _thoughtController.clear();
      setState(() {
        _isComposing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your thought has been shared!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _toggleLike(String thoughtId, int currentLikes) async {
    try {
      await _firestore.collection('thoughts').doc(thoughtId).update({
        'likes': currentLikes + 1,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _thoughtController.dispose();
    _scrollController.dispose();
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Thought Board'),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _thoughtsStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No thoughts yet',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Be the first to share your thought!',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  controller: _scrollController,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    final data = doc.data() as Map<String, dynamic>;

                    // Format timestamp
                    String timeDisplay = 'Just now';
                    if (data['timestamp'] != null) {
                      final Timestamp timestamp =
                          data['timestamp'] as Timestamp;
                      final DateTime dateTime = timestamp.toDate();
                      final DateTime now = DateTime.now();
                      final Duration difference = now.difference(dateTime);

                      if (difference.inDays > 0) {
                        timeDisplay =
                            '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
                      } else if (difference.inHours > 0) {
                        timeDisplay =
                            '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
                      } else if (difference.inMinutes > 0) {
                        timeDisplay =
                            '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
                      }
                    }

                    // Check if post is by current user
                    final bool isMe =
                        _auth.currentUser?.uid == data['authorId'];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Card(
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color:
                                isMe
                                    ? Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.3)
                                    : Colors.grey.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor:
                                        isMe
                                            ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                            : Colors.blue[300],
                                    child: Text(
                                      data['authorName'].toString().substring(
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
                                  Text(
                                    data['authorName'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    timeDisplay,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                data['text'],
                                style: const TextStyle(fontSize: 15),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        size: 16,
                                        color: Colors.red[400],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${data['likes']}',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap:
                                        () =>
                                            _toggleLike(doc.id, data['likes']),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.favorite_border,
                                            size: 16,
                                            color: Colors.red[400],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Like',
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
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
                Expanded(
                  child: TextField(
                    controller: _thoughtController,
                    decoration: InputDecoration(
                      hintText: 'Share your thought...',
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
                      suffixIcon:
                          _isComposing
                              ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Shake to clear',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              )
                              : null,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 1,
                    maxLines: 5,
                    onChanged: (text) {
                      setState(() {
                        _isComposing = text.isNotEmpty;
                      });
                    },
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
                      _addThought(_thoughtController.text);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _selectedIndex,
        parentContext: context,
      ),
    );
  }
}
