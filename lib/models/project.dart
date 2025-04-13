// Project model class
import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentSnapshot, Timestamp;

class Project {
  final String id;
  final String title;
  final String summary;
  final String description;
  final String? link;
  final String userId;
  final DateTime createdAt;

  Project({
    required this.id,
    required this.title,
    required this.summary,
    required this.description,
    this.link,
    required this.userId,
    required this.createdAt,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'summary': summary,
      'description': description,
      'link': link,
      'userId': userId,
      'createdAt': createdAt,
    };
  }

  // Create Project from Firestore document
  factory Project.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Project(
      id: doc.id,
      title: data['title'] ?? '',
      summary: data['summary'] ?? '',
      description: data['description'] ?? '',
      link: data['link'],
      userId: data['userId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
