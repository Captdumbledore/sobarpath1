import 'package:flutter/material.dart';
import '../models/job.dart';
import 'task_screen.dart';

class JobDetailsScreen extends StatelessWidget {
  final Job job;

  const JobDetailsScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue[100],
                child: Text(
                  job.company[0],
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.title,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Bandung, Jawa Barat',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.bookmark_border),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Chip(
                    label: const Text('Remote'),
                    backgroundColor: Colors.grey[200],
                  ),
                  Chip(
                    label: const Text('Intermediate'),
                    backgroundColor: Colors.grey[200],
                  ),
                  Chip(
                    label: const Text('Full Time'),
                    backgroundColor: Colors.grey[200],
                  ),
                ],
              ),
            ),
            const TabBar(
              tabs: [
                Tab(text: 'Description'),
                Tab(text: 'Company'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Job Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'We are currently looking for a web developer with 2 years experience, and can operate our product, namely web builder, we will recruit candidates on a full time basis and can work from anywhere, also WFA',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'A Must Have Skill',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('• Java script',
                                style: TextStyle(color: Colors.grey[600])),
                            Text('• HTML CSS',
                                style: TextStyle(color: Colors.grey[600])),
                            Text('• Mastering web builder especially webflow',
                                style: TextStyle(color: Colors.grey[600])),
                            Text('• PHP',
                                style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Center(child: Text('Company Information')),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskScreen(job: job),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Apply Job'),
          ),
        ),
      ),
    );
  }
}
