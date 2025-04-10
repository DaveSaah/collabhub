import 'package:flutter/material.dart';

class ProjectListingsScreen extends StatefulWidget {
  const ProjectListingsScreen({super.key});

  @override
  _ProjectListingsScreenState createState() => _ProjectListingsScreenState();
}

class _ProjectListingsScreenState extends State<ProjectListingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> projects = [
    {'title': 'Project Alpha', 'description': 'An AI-powered chatbot.'},
    {
      'title': 'HealthTech App',
      'description': 'A mobile app for healthcare solutions.',
    },
    {
      'title': 'Open Source CMS',
      'description': 'A community-driven CMS platform.',
    },
    {
      'title': 'Blockchain Voting',
      'description': 'A decentralized voting system.',
    },
    {
      'title': 'E-commerce Platform',
      'description': 'An online marketplace for small businesses.',
    },
  ];

  List<Map<String, String>> filteredProjects = [];

  @override
  void initState() {
    super.initState();
    filteredProjects = projects;
  }

  void _filterProjects(String query) {
    setState(() {
      filteredProjects =
          projects
              .where(
                (project) => project['title']!.toLowerCase().contains(
                  query.toLowerCase(),
                ),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the current theme

    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Listings'),
        automaticallyImplyLeading: false, // This removes the back button
        // backgroundColor: theme.colorScheme.primary, // Use the primary color
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pop(context); // Navigate back to the previous screen
        //   },
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search projects...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: _filterProjects,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredProjects.length,
                itemBuilder: (context, index) {
                  var project = filteredProjects[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        project['title']!,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        project['description']!,
                        style: theme.textTheme.bodyMedium,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text('View'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  theme
                                      .colorScheme
                                      .primary, // Use the primary color
                            ),
                            child: const Text(
                              'Join',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
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
