
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() =>
      _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {

  // Storage key used to save attendance
  static const String storageKey = 'campus_attendance';

  // All subjects
  final List<Map<String, dynamic>> subjects = [
    {
      'name': 'Mathematics',
      'present': 0,
      'total': 0,
    },
    {
      'name': 'Physics',
      'present': 0,
      'total': 0,
    },
    {
      'name': 'Chemistry',
      'present': 0,
      'total': 0,
    },
    {
      'name': 'Computer Science',
      'present': 0,
      'total': 0,
    },
    {
      'name': 'English',
      'present': 0,
      'total': 0,
    },
    {
      'name': 'EOC',
      'present': 0,
      'total': 0,
    },
    {
      'name': 'TAMIL',
      'present': 0,
      'total': 0,
    },
    {
      'name': 'LIFE SKILL',
      'present': 0,
      'total': 0,
    },
    {
      'name': 'MAKERSPACE',
      'present': 0,
      'total': 0,
    },
  ];

  bool isLoading = true;

  // Load saved attendance when screen opens
  @override
  void initState() {
    super.initState();
    loadAttendance();
  }

  // Load attendance from phone storage
  Future<void> loadAttendance() async {

    try {
      final prefs = await SharedPreferences.getInstance();

      final savedData = prefs.getString(storageKey);

      if (savedData != null) {

        final List<dynamic> savedSubjects =
            jsonDecode(savedData);

        for (final savedSubject in savedSubjects) {

          final index = subjects.indexWhere(
            (subject) =>
                subject['name'] == savedSubject['name'],
          );

          if (index != -1) {

            final present =
                savedSubject['present'] as int;

            final total =
                savedSubject['total'] as int;

            // Prevent invalid saved values
            subjects[index]['total'] =
                total < 0 ? 0 : total;

            subjects[index]['present'] =
                present < 0
                    ? 0
                    : (present > total ? total : present);
          }
        }
      }

    } catch (e) {

      debugPrint('Attendance loading error: $e');

    }

    if (mounted) {

      setState(() {
        isLoading = false;
      });

    }
  }

  // Save attendance to phone storage
  Future<void> saveAttendance() async {

    try {

      final prefs = await SharedPreferences.getInstance();

      final savedData = jsonEncode(subjects);

      await prefs.setString(
        storageKey,
        savedData,
      );

    } catch (e) {

      debugPrint('Attendance saving error: $e');

      if (mounted) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Unable to save attendance.',
            ),
          ),
        );

      }
    }
  }

  // Calculate attendance percentage
  double percentage(
    Map<String, dynamic> subject,
  ) {

    int total = subject['total'];

    if (total == 0) {
      return 0;
    }

    return subject['present'] / total * 100;
  }

  // Mark Present or Absent
  void markAttendance(
    int index,
    bool present,
  ) {

    setState(() {

      subjects[index]['total']++;

      if (present) {

        subjects[index]['present']++;

      }

    });

    // Save automatically
    saveAttendance();
  }

  // Reset one subject
  void resetAttendance(int index) {

    setState(() {

      subjects[index]['present'] = 0;

      subjects[index]['total'] = 0;

    });

    // Save reset data
    saveAttendance();
  }

  // Clear attendance for all subjects
  Future<void> clearAllAttendance() async {

    final confirm = await showDialog<bool>(
      context: context,

      builder: (context) {

        return AlertDialog(

          title: const Text(
            'Clear Attendance?',
          ),

          content: const Text(
            'This will clear attendance for all subjects. '
            'This action cannot be undone.',
          ),

          actions: [

            TextButton(

              onPressed: () {
                Navigator.pop(context, false);
              },

              child: const Text('Cancel'),

            ),

            ElevatedButton(

              onPressed: () {
                Navigator.pop(context, true);
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),

              child: const Text('Clear'),

            ),

          ],

        );

      },
    );

    if (confirm == true) {

      setState(() {

        for (final subject in subjects) {

          subject['present'] = 0;

          subject['total'] = 0;

        }

      });

      await saveAttendance();

      if (mounted) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Attendance cleared successfully!',
            ),
          ),
        );

      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF5F3FA),

      appBar: AppBar(

        title: const Text(
          'Attendance Tracker',
        ),

        backgroundColor: Colors.purple,

        foregroundColor: Colors.white,

        actions: [

          IconButton(

            tooltip: 'Clear all attendance',

            icon: const Icon(
              Icons.delete_outline,
            ),

            onPressed: clearAllAttendance,

          ),

        ],

      ),

      body: isLoading

          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.purple,
              ),
            )

          : ListView.builder(

              padding: const EdgeInsets.all(12),

              itemCount: subjects.length,

              itemBuilder: (context, index) {

                final subject = subjects[index];

                final percent = percentage(subject);

                return Card(

                  margin: const EdgeInsets.only(
                    bottom: 15,
                  ),

                  child: Padding(

                    padding: const EdgeInsets.all(16),

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        // Subject name
                        Text(

                          subject['name'],

                          style: const TextStyle(

                            fontSize: 20,

                            fontWeight: FontWeight.bold,

                          ),

                        ),

                        const SizedBox(height: 10),

                        // Present and total classes
                        Text(

                          'Present: ${subject['present']} / '
                          '${subject['total']} classes',

                        ),

                        const SizedBox(height: 10),

                        // Attendance progress bar
                        LinearProgressIndicator(

                          value: percent / 100,

                          minHeight: 8,

                          color: Colors.purple,

                          backgroundColor:
                              Colors.purple.shade100,

                        ),

                        const SizedBox(height: 8),

                        // Attendance percentage
                        Text(

                          'Attendance: '
                          '${percent.toStringAsFixed(1)}%',

                          style: const TextStyle(

                            fontWeight: FontWeight.bold,

                          ),

                        ),

                        const SizedBox(height: 15),

                        // Present and Absent buttons
                        Row(

                          children: [

                            Expanded(

                              child: ElevatedButton(

                                onPressed: () {

                                  markAttendance(
                                    index,
                                    true,
                                  );

                                },

                                style: ElevatedButton.styleFrom(

                                  backgroundColor: Colors.green,

                                  foregroundColor: Colors.white,

                                ),

                                child: const Text(
                                  'Present',
                                ),

                              ),

                            ),

                            const SizedBox(width: 10),

                            Expanded(

                              child: ElevatedButton(

                                onPressed: () {

                                  markAttendance(
                                    index,
                                    false,
                                  );

                                },

                                style: ElevatedButton.styleFrom(

                                  backgroundColor: Colors.red,

                                  foregroundColor: Colors.white,

                                ),

                                child: const Text(
                                  'Absent',
                                ),

                              ),

                            ),

                          ],

                        ),

                        // Individual subject reset
                        Align(

                          alignment: Alignment.centerRight,

                          child: TextButton(

                            onPressed: () {

                              resetAttendance(index);

                            },

                            child: const Text(
                              'Reset',
                            ),

                          ),

                        ),

                      ],

                    ),

                  ),

                );

              },

            ),

    );

  }

}
