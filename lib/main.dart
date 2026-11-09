
import 'package:flutter/material.dart';

void main() {
  runApp(const CampusCompanion());
}

class CampusCompanion extends StatelessWidget {
  const CampusCompanion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campus Companion',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      appBar: AppBar(
        title: const Text(
          'Campus Companion',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              'Welcome, Student!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Your college life, organized.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,

                children: [

                  featureCard(
                    Icons.book,
                    'Study Planner',
                    Colors.blue,
                  ),

                  featureCard(
                    Icons.restaurant,
                    'Canteen',
                    Colors.orange,
                  ),

                  featureCard(
                    Icons.security,
                    'Cyber Safety',
                    Colors.green,
                  ),

                  featureCard(
                    Icons.calendar_month,
                    'Attendance',
                    Colors.purple,
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget featureCard(
    IconData icon,
    String title,
    Color color,
  ) {
    return Card(
      elevation: 3,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Icon(
            icon,
            size: 45,
            color: color,
          ),

          const SizedBox(height: 12),

          Text(
            title,
            textAlign: TextAlign.center,

            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

        ],
      ),
    );
  }
}
