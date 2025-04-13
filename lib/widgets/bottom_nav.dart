import 'package:flutter/material.dart';
import 'package:collabhub/features/projects/project_listings_screen.dart';
import 'package:collabhub/features/projects/my_project_screen.dart';
import 'package:collabhub/features/collaborations/collab_screen.dart';
import 'package:collabhub/features/chat/chat_screen.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final BuildContext parentContext;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.parentContext,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (currentIndex == index) {
      // User tapped the current tab, do nothing
      return;
    }

    // Navigate to the appropriate screen based on the selected index
    switch (index) {
      case 0:
        // Navigate to Home/ProjectListings screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ProjectListingsScreen(),
          ),
        );
        break;
      case 1:
        // Navigate to My Projects screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyProjectScreen()),
        );
        break;
      case 2:
        // Navigate to Collabs screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CollabsScreen()),
        );
        break;
      case 3:
        // Navigate to Chat screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ChatScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_outlined),
              activeIcon: Icon(Icons.folder),
              label: 'My Projects',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'Collabs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'Chat',
            ),
          ],
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          elevation: 0,
          backgroundColor: Colors.white,
          onTap: (index) => _onItemTapped(context, index),
          selectedFontSize: 12,
          unselectedFontSize: 12,
        ),
      ),
    );
  }
}
