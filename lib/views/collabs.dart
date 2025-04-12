import 'package:flutter/material.dart';

class CollabsScreen extends StatefulWidget {
  const CollabsScreen({super.key});

  @override
  State<CollabsScreen> createState() => _CollabsScreenState();
}

class _CollabsScreenState extends State<CollabsScreen> {
  // Sample collaborators data
  final List<Map<String, dynamic>> collaborators = [
    {
      'name': 'Alex Johnson',
      'role': 'UI/UX Designer',
      'email': 'alex.johnson@ashesi.edu.gh',
      'projects': 3,
      'imageUrl': 'https://i.pravatar.cc/150?img=1',
      'skills': ['UI Design', 'Prototyping', 'User Research'],
    },
    {
      'name': 'Maya Patel',
      'role': 'Backend Developer',
      'email': 'maya.patel@ashesi.edu.gh',
      'projects': 5,
      'imageUrl': 'https://i.pravatar.cc/150?img=5',
      'skills': ['Python', 'Django', 'PostgreSQL'],
    },
    {
      'name': 'David Osei',
      'role': 'Mobile Developer',
      'email': 'david.osei@ashesi.edu.gh',
      'projects': 2,
      'imageUrl': 'https://i.pravatar.cc/150?img=8',
      'skills': ['Flutter', 'Firebase', 'Dart'],
    },
    {
      'name': 'Sarah Mensah',
      'role': 'Project Manager',
      'email': 'sarah.mensah@ashesi.edu.gh',
      'projects': 7,
      'imageUrl': 'https://i.pravatar.cc/150?img=10',
      'skills': ['Agile', 'Scrum', 'Team Leadership'],
    },
    {
      'name': 'Kwame Adu',
      'role': 'Frontend Developer',
      'email': 'kwame.adu@ashesi.edu.gh',
      'projects': 4,
      'imageUrl': 'https://i.pravatar.cc/150?img=12',
      'skills': ['React', 'JavaScript', 'CSS'],
    },
  ];

  // Search functionality
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredCollaborators = [];

  @override
  void initState() {
    super.initState();
    filteredCollaborators = collaborators;
  }

  void _filterCollaborators(String query) {
    setState(() {
      filteredCollaborators =
          collaborators
              .where(
                (collab) =>
                    collab['name']!.toLowerCase().contains(
                      query.toLowerCase(),
                    ) ||
                    collab['role']!.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Collaborators'),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search collaborators...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: _filterCollaborators,
            ),
          ),

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('All'),
                _buildFilterChip('Developers'),
                _buildFilterChip('Designers'),
                _buildFilterChip('Project Managers'),
                _buildFilterChip('Data Scientists'),
              ],
            ),
          ),

          // Collaborators list
          Expanded(
            child:
                filteredCollaborators.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_search,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No collaborators found',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredCollaborators.length,
                      itemBuilder: (context, index) {
                        final collaborator = filteredCollaborators[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.grey[200],
                              child: Text(
                                collaborator['name'].toString().substring(0, 1),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            title: Text(
                              collaborator['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  collaborator['role'],
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children:
                                      (collaborator['skills'] as List<String>)
                                          .take(2)
                                          .map(
                                            (skill) => Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[100],
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                skill,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList()
                                        ..add(
                                          (collaborator['skills']
                                                          as List<String>)
                                                      .length >
                                                  2
                                              ? Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[100],
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  '+${(collaborator['skills'] as List<String>).length - 2}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[800],
                                                  ),
                                                ),
                                              )
                                              : Container(),
                                        ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${collaborator['projects']} projects',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 0,
                                        ),
                                        minimumSize: const Size(80, 28),
                                        textStyle: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      child: const Text('Connect'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () {
                              // Show collaborator profile or details
                            },
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = label == 'All';
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          // Filter logic would go here
        },
        backgroundColor: Colors.white,
        selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        labelStyle: TextStyle(
          color:
              isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[800],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      ),
    );
  }
}
