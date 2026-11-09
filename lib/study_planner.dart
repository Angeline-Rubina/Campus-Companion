
import 'package:flutter/material.dart';

class StudyPlanner extends StatefulWidget {
  const StudyPlanner({super.key});

  @override
  State<StudyPlanner> createState() => _StudyPlannerState();
}

class _StudyPlannerState extends State<StudyPlanner> {
  final List<Map<String, dynamic>> tasks = [];

  final TextEditingController subjectController =
      TextEditingController();

  final TextEditingController taskController =
      TextEditingController();

  void addTask() {
    subjectController.clear();
    taskController.clear();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Study Task'),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              TextField(
                controller: subjectController,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  hintText: 'Example: Mathematics',
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: taskController,
                decoration: const InputDecoration(
                  labelText: 'Study Task',
                  hintText: 'Example: Complete Chapter 3',
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                String subject =
                    subjectController.text.trim();

                String task =
                    taskController.text.trim();

                if (subject.isEmpty || task.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Enter both subject and task',
                      ),
                    ),
                  );

                  return;
                }

                setState(() {
                  tasks.add({
                    'subject': subject,
                    'task': task,
                    'completed': false,
                  });
                });

                Navigator.pop(dialogContext);
              },

              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  int get completedCount {
    return tasks.where((task) {
      return task['completed'] == true;
    }).length;
  }

  int get pendingCount {
    return tasks.length - completedCount;
  }

  @override
  void dispose() {
    subjectController.dispose();
    taskController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      appBar: AppBar(
        title: const Text(
          'Student Study Planner',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Your Study Tasks',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.green.shade100,

                    child: Padding(
                      padding: const EdgeInsets.all(12),

                      child: Column(
                        children: [
                          const Text('Completed'),

                          const SizedBox(height: 5),

                          Text(
                            '$completedCount',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Card(
                    color: Colors.orange.shade100,

                    child: Padding(
                      padding: const EdgeInsets.all(12),

                      child: Column(
                        children: [
                          const Text('Pending'),

                          const SizedBox(height: 5),

                          Text(
                            '$pendingCount',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Expanded(
              child: tasks.isEmpty
                  ? const Center(
                      child: Text(
                        'No study tasks yet.\nTap + to add your first task.',
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey,
                        ),
                      ),
                    )

                  : ListView.builder(
                      itemCount: tasks.length,

                      itemBuilder: (context, index) {
                        final task = tasks[index];

                        return Card(
                          margin: const EdgeInsets.only(
                            bottom: 10,
                          ),

                          child: ListTile(
                            leading: Checkbox(
                              value: task['completed'],

                              onChanged: (value) {
                                setState(() {
                                  task['completed'] = value;
                                });
                              },
                            ),

                            title: Text(
                              task['subject'],

                              style: TextStyle(
                                fontWeight: FontWeight.bold,

                                decoration:
                                    task['completed'] == true
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                              ),
                            ),

                            subtitle: Text(
                              task['task'],
                            ),

                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),

                              onPressed: () {
                                deleteTask(index);
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: addTask,

        backgroundColor: Colors.green,
        foregroundColor: Colors.white,

        child: const Icon(Icons.add),
      ),
    );
  }
}
