import 'package:flutter/material.dart';
import 'package:collabhub/views/myproject.dart';
import 'package:collabhub/views/collabs.dart';
import 'package:collabhub/views/chat.dart';

class ProjectListingsScreen extends StatefulWidget {
  const ProjectListingsScreen({super.key});

  @override
  _ProjectListingsScreenState createState() => _ProjectListingsScreenState();
}

class _ProjectListingsScreenState extends State<ProjectListingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0; // Track the selected navigation item

  List<Map<String, dynamic>> projects = [
    {
      'title': 'Project Alpha',
      'description':
          'An AI-powered chatbot for customer support with natural language processing capabilities.',
      'collaborators': ['Alex Kim', 'Jamie Chen', 'Taylor Wong'],
    },
    {
      'title': 'HealthTech App',
      'description':
          'A mobile app for healthcare solutions that connects patients with doctors and provides medication reminders.',
      'collaborators': ['Morgan Lee', 'Casey Johnson', 'Jordan Smith'],
    },
    {
      'title': 'Open Source CMS',
      'description':
          'A community-driven content management system platform built with modern web technologies.',
      'collaborators': ['Riley Parker', 'Quinn Adams', 'Sam Rivera'],
    },
    {
      'title': 'Blockchain Voting',
      'description':
          'A decentralized voting system that ensures transparency and security in electoral processes.',
      'collaborators': ['Avery Thomas', 'Blake Martinez', 'Cameron Rodriguez'],
    },
    {
      'title': 'E-commerce Platform',
      'description':
          'An online marketplace for small businesses with integrated payment systems and inventory management.',
      'collaborators': ['Dana Wilson', 'Jesse Brown', 'Pat Garcia'],
    },
  ];

  List<Map<String, dynamic>> filteredProjects = [];

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

  void _showProjectDetails(Map<String, dynamic> project) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.75,
            builder:
                (_, controller) => Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: ListView(
                    controller: controller,
                    children: [
                      // Handle for dragging
                      Center(
                        child: Container(
                          width: 60,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(3),
                          ),
                          margin: const EdgeInsets.only(bottom: 20),
                        ),
                      ),

                      // Project Title
                      Text(
                        project['title'],
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Description Section
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        project['description'],
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(height: 1.5),
                      ),
                      const SizedBox(height: 24),

                      // Collaborators Section
                      Text(
                        'Collaborators',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      ...List.generate(
                        project['collaborators'].length,
                        (index) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.2),
                            child: Text(
                              project['collaborators'][index][0],
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(project['collaborators'][index]),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Join button at the bottom
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Joined ${project['title']}!'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.group_add),
                        label: const Text('Join Project'),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      // User tapped the current tab, do nothing
      return;
    }

    // Navigate to the appropriate screen based on the selected index
    switch (index) {
      case 0:
        // Already on Home/ProjectListings screen
        setState(() {
          _selectedIndex = index;
        });
        break;
      case 1:
        // Navigate to My Projects screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyProjectScreen()),
        ).then((_) {
          // When returning to this screen, ensure the index is reset to 0
          setState(() {
            _selectedIndex = 0;
          });
        });
        break;
      case 2:
        // Navigate to Collabs screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CollabsScreen()),
        ).then((_) {
          // When returning to this screen, ensure the index is reset to 0
          setState(() {
            _selectedIndex = 0;
          });
        });
        break;
      case 3:
        // Navigate to Chat screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatScreen()),
        ).then((_) {
          // When returning to this screen, ensure the index is reset to 0
          setState(() {
            _selectedIndex = 0;
          });
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Discover Projects'),
        elevation: 0,
        centerTitle: true,
        actions: [],
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Theme.of(context).primaryColor.withOpacity(0.05),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search projects...',
                prefixIcon: const Icon(Icons.search),
                // suffixIcon: IconButton(
                //   icon: const Icon(Icons.tune),
                //   onPressed: () {},
                // ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onChanged: _filterProjects,
            ),
          ),
          Expanded(
            child:
                filteredProjects.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No projects found',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredProjects.length,
                      itemBuilder: (context, index) {
                        var project = filteredProjects[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                offset: const Offset(0, 4),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      project['title'],
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      project['description'],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.grey[600]),
                                    ),
                                    const SizedBox(height: 16),
                                    Wrap(
                                      spacing: 4,
                                      children: List.generate(
                                        project['collaborators'].length > 3
                                            ? 3
                                            : project['collaborators'].length,
                                        (i) => Chip(
                                          label: Text(
                                            project['collaborators'][i],
                                          ),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.1),
                                          labelStyle: TextStyle(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                            fontSize: 12,
                                          ),
                                          padding: EdgeInsets.zero,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextButton.icon(
                                        onPressed:
                                            () => _showProjectDetails(project),
                                        icon: const Icon(
                                          Icons.visibility_outlined,
                                        ),
                                        label: const Text('View Details'),
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      height: 24,
                                      width: 1,
                                      color: Colors.grey[300],
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: TextButton.icon(
                                        onPressed: () {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Joined ${project['title']}!',
                                              ),
                                            ), // abeiku do your magic here ;)
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.group_add_outlined,
                                        ),
                                        label: const Text('Join Project'),
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          foregroundColor:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                        ),
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // abeiku do your magic here
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: Container(
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
            currentIndex: _selectedIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            elevation: 0,
            backgroundColor: Colors.white,
            onTap: _onItemTapped,
            selectedFontSize: 12,
            unselectedFontSize: 12,
          ),
        ),
      ),
    );
  }
}
