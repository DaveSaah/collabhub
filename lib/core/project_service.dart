import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collabhub/models/project.dart' show Project;
import 'package:firebase_auth/firebase_auth.dart';

class ProjectService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get reference to projects collection
  CollectionReference get _projectsCollection =>
      _firestore.collection('projects');

  // Create a new project
  Future<String> createProject({
    required String title,
    required String summary,
    required String description,
    required String skills,
    String? link,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    final projectData = {
      'title': title,
      'summary': summary,
      'description': description,
      'link': link,
      'userId': currentUser.uid,
      'createdAt': FieldValue.serverTimestamp(),
      'skills': skills,
    };

    final docRef = await _projectsCollection.add(projectData);
    return docRef.id;
  }

  // Get all projects for current user
  Stream<List<Project>> getUserProjects() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.value([]);
    }

    return _projectsCollection
        .where('userId', isEqualTo: currentUser.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Project.fromDocument(doc)).toList();
        });
  }

  // Get all projects for current user
  Stream<List<Project>> getAllProjects() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.value([]);
    }

    return _projectsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Project.fromDocument(doc)).toList();
        });
  }

  // Delete project
  Future<void> deleteProject(String projectId) {
    return _projectsCollection.doc(projectId).delete();
  }

  // Update project
  Future<void> updateProject({
    required String projectId,
    required String title,
    required String summary,
    required String description,
    required String skills,
    String? link,
  }) {
    return _projectsCollection.doc(projectId).update({
      'title': title,
      'summary': summary,
      'description': description,
      'link': link,
      'updatedAt': FieldValue.serverTimestamp(),
      'skills': skills,
    });
  }
}
