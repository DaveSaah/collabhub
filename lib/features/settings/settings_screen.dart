import 'package:collabhub/core/auth_service.dart';
import 'package:collabhub/features/auth/login_screen.dart';
import 'package:collabhub/main.dart';
import 'package:flutter/material.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Account Settings',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Account Settings Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'ACCOUNT',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      offset: const Offset(0, 2),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Divider(height: 1),
                    _buildSettingsItem(
                      context,
                      icon: Icons.notifications_outlined,
                      iconColor: Colors.orange,
                      title: 'Notifications',
                      subtitle: 'Manage notification preferences',
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _buildSettingsItem(
                      context,
                      icon: Icons.logout,
                      iconColor: Colors.redAccent,
                      title: 'Logout',
                      subtitle: 'Sign out of your account',
                      onTap: () async {
                        await authService.signOut();
                        MyApp.navigatorKey.currentState?.pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Footer
              Container(
                padding: const EdgeInsets.symmetric(vertical: 30),
                alignment: Alignment.center,
                child: Text(
                  '© 2025 Janvier',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showChevron = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            if (showChevron) Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
