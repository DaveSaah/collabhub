import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text(
          "Settings",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme option
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.brightness_6,  // Light/dark mode toggle icon
                  color: Colors.deepPurple,
                ),
              ),
              title: const Text(
                "Appearance",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                size: 20,
                color: Colors.grey,
              ),
              onTap: () {
                // Navigate to theme settings
              },
            ),
            
            const Divider(height: 8),
            
            // Security Settings
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.shield,  // Google's shield security icon
                  color: Colors.deepPurple,
                ),
              ),
              title: const Text(
                "Privacy & Security",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                size: 20,
                color: Colors.grey,
              ),
              onTap: () {
                // Navigate to security settings
              },
            ),
            
            const Divider(height: 8),
            
            // Profile Settings
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.person,  // Google's person icon
                  color: Colors.deepPurple,
                ),
              ),
              title: const Text(
                "My Profile",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                size: 20,
                color: Colors.grey,
              ),
              onTap: () {
                // Navigate to profile settings
              },
            ),
            
            const Divider(height: 8),
            
            // Notification Preferences
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.notifications,  // Google's notifications icon
                  color: Colors.deepPurple,
                ),
              ),
              title: const Text(
                "Notifications",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                size: 20,
                color: Colors.grey,
              ),
              onTap: () {
                // Navigate to notification preferences
              },
            ),
            
            const Divider(height: 8),
            
            // Help & Support
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.support,  // Google's support icon
                  color: Colors.deepPurple,
                ),
              ),
              title: const Text(
                "Help & Support",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                size: 20,
                color: Colors.grey,
              ),
              onTap: () {
                // Navigate to help & support
              },
            ),
            
            const Divider(height: 8),
            
            // Sign Out
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.logout,  // Google's logout icon
                  color: Colors.deepPurple,
                ),
              ),
              title: const Text(
                "Sign out",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                // Sign out functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}