import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/job.dart';
import 'job_details_screen.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});

  @override
  _JobListScreenState createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  void _addMoreJobs() {
    final jobBox = Hive.box<Job>('jobs');

    // Get current highest ID
    final allJobs = jobBox.values.toList();
    final lastId = allJobs.isEmpty
        ? 0
        : allJobs
            .map((job) => int.parse(job.id))
            .reduce((max, id) => id > max ? id : max);

    final newJobs = [
      Job(
        id: '${lastId + 1}',
        title: 'AR/VR Developer',
        company: 'Meta',
        salary: '22.000.000 - 30.000.000',
        type: ['Remote', 'Expert', 'Full Time'],
      ),
      Job(
        id: '${lastId + 2}',
        title: 'Cloud Security Engineer',
        company: 'AWS',
        salary: '25.000.000 - 35.000.000',
        type: ['Hybrid', 'Senior', 'Full Time'],
      ),
      Job(
        id: '${lastId + 3}',
        title: 'Full Stack Developer',
        company: 'Shopify',
        salary: '18.000.000 - 25.000.000',
        type: ['Remote', 'Intermediate', 'Contract'],
      ),
      Job(
        id: '${lastId + 4}',
        title: 'AI Research Engineer',
        company: 'OpenAI',
        salary: '30.000.000 - 45.000.000',
        type: ['On-site', 'Expert', 'Full Time'],
      ),
      Job(
        id: '${lastId + 5}',
        title: 'Quantum Computing Engineer',
        company: 'IBM',
        salary: '35.000.000 - 50.000.000',
        type: ['Hybrid', 'Expert', 'Full Time'],
      ),
    ];

    // Use putAll instead of add to ensure proper storage
    final Map<dynamic, Job> jobMap = {
      for (var i = 0; i < newJobs.length; i++) i + jobBox.length: newJobs[i]
    };

    jobBox.putAll(jobMap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Job Listings'),
            const SizedBox(width: 8),
            ValueListenableBuilder(
              valueListenable: Hive.box<Job>('jobs').listenable(),
              builder: (context, Box<Job> box, _) {
                return Text('(${box.length})'); // Show total count
              },
            ),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addMoreJobs,
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Job>('jobs').listenable(),
        builder: (context, Box<Job> box, _) {
          final allJobs = box.values.toList()
            ..sort((a, b) => int.parse(b.id).compareTo(int.parse(a.id)));

          if (allJobs.isEmpty) {
            return const Center(
              child: Text('No jobs available'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: allJobs.length,
            itemBuilder: (context, index) {
              final job = allJobs[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobDetailsScreen(job: job),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        job.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.bookmark_border),
                                        onPressed: () {
                                          // Handle bookmark
                                        },
                                      ),
                                    ],
                                  ),
                                  Text(
                                    job.salary,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: job.type
                              .map((type) => Chip(
                                    label: Text(type),
                                    backgroundColor: const Color(0xFFEEEEEE),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
