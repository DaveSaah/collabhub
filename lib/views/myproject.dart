import 'package:flutter/material.dart';

class MyProjectScreen extends StatefulWidget {
  const MyProjectScreen({super.key});

  @override
  State<MyProjectScreen> createState() => _MyProjectScreenState();
}

class _MyProjectScreenState extends State<MyProjectScreen> {
  // Sample projects data
  final List<Map<String, dynamic>> myProjects = [
    {
      'title': 'Mobile Banking App',
      'role': 'Team Lead',
      'progress': 0.7,
      'dueDate': '2025-05-15',
      'members': 4,
    },
    {
      'title': 'Learning Management System',
      'role': 'Developer',
      'progress': 0.4,
      'dueDate': '2025-06-30',
      'members': 6,
    },
    {
      'title': 'Campus Navigation Tool',
      'role': 'UI Designer',
      'progress': 0.9,
      'dueDate': '2025-04-20',
      'members': 3,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('My Projects'),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: myProjects.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_open,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No projects yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Join or create a project to get started',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[500],
                        ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('Create New Project'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: myProjects.length,
              itemBuilder: (context, index) {
                final project = myProjects[index];
                final dueDate = DateTime.parse(project['dueDate']);
                final now = DateTime.now();
                final daysLeft = dueDate.difference(now).inDays;
                
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    project['title'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    project['role'],
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Due in $daysLeft days',
                                  style: TextStyle(
                                    color: daysLeft < 7
                                        ? Colors.red
                                        : Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Icon(
                                  Icons.people,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${project['members']} members',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Progress',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '${(project['progress'] * 100).round()}%',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: project['progress'],
                                    backgroundColor: Colors.grey[200],
                                    minHeight: 8,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
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
                                onPressed: () {},
                                icon: const Icon(Icons.task_alt),
                                label: const Text('Tasks'),
                                style: TextButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            ),
                            Container(height: 24, width: 1, color: Colors.grey[300]),
                            Expanded(
                              child: TextButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.chat_outlined),
                                label: const Text('Chat'),
                                style: TextButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            ),
                            Container(height: 24, width: 1, color: Colors.grey[300]),
                            Expanded(
                              child: TextButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.info_outline),
                                label: const Text('Details'),
                                style: TextButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
