import 'package:collabhub/components/info_card.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
        actions: [IconButton(icon: const Icon(Icons.edit), onPressed: () {})],
      ),
      // wrap column with padding
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 40.0, right: 40.0),
        child: Center(
          child: Column(
            children: [
              // create a profile picture
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 50),
              ),
              Text(
                'Janvier',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              InfoCard(
                title: 'Bio',
                icon: Icons.segment,
                description: 'Software Engineer',
              ),
              InfoCard(
                title: "Skills",
                icon: Icons.star,
                description: "Flutter, Dart, Python",
              ),
              InfoCard(
                title: "Portfolio",
                icon: Icons.work,
                description: "https://example.com",
              ),
              InfoCard(
                title: "People I've Worked With",
                icon: Icons.people,
                description: "John Doe, Jane Smith",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
