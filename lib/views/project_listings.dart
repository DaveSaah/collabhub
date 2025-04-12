import 'package:flutter/material.dart';
import 'add_project.dart';

class ProjectListingsScreen extends StatefulWidget {
  const ProjectListingsScreen({super.key});

  @override
  _ProjectListingsScreenState createState() => _ProjectListingsScreenState();
}

class _ProjectListingsScreenState extends State<ProjectListingsScreen> {
  final TextEditingController _searchController = TextEditingController();

  // List to store projects added by users
  List<Map<String, String>> projects = [];

  // Filtered list for search functionality
  List<Map<String, String>> filteredProjects = [];

  @override
  void initState() {
    super.initState();
    filteredProjects =
        projects; // Initially, filteredProjects is the same as projects
  }

  // Method to filter projects based on search query
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

  // Method to show the Add Project dialog and handle the result
  void _showAddProjectDialog(BuildContext context) async {
    final newProject = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const AddProjectDialog(),
    );

    if (newProject != null) {
      setState(() {
        projects.add(newProject); // Add the new project to the list
        filteredProjects = projects; // Update the filtered list
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the current theme

    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Listings'),
        automaticallyImplyLeading: false, // This removes the back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search projects...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: _filterProjects, // Filter projects as the user types
            ),
            const SizedBox(height: 16),
            // List of projects
            Expanded(
              child:
                  filteredProjects.isEmpty
                      ? const Center(child: Text('No projects found.'))
                      : ListView.builder(
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
                                          theme.colorScheme.primary,
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
      // Floating action button to add a new project
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProjectDialog(context),
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
