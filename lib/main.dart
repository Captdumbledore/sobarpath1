import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'self_analyzer/self1.dart';
import 'quick_work/home.dart';
import 'community/com1.dart';
import 'mood_analyser/analyser.dart';
import 'community/models/community_question.dart';
import 'community/models/post.dart';
import 'community/models/joined_community.dart';
import 'models/job.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Adapters
  if (!Hive.isAdapterRegistered(4)) {
    Hive.registerAdapter(JobAdapter());
  }
  Hive.registerAdapter(CommunityQuestionAdapter());
  Hive.registerAdapter(PostAdapter());
  Hive.registerAdapter(JoinedCommunityAdapter());

  // Open Boxes
  await Hive.openBox<CommunityQuestion>('questions');
  await Hive.openBox<Post>('posts');
  await Hive.openBox<JoinedCommunity>('joined_communities');
  await Hive.openBox<Job>('jobs');

  // Initialize sample job data
  final jobBox = Hive.box<Job>('jobs');
  // Clear existing data to avoid duplicates
  await jobBox.clear();

  if (jobBox.isEmpty) {
    jobBox.addAll([
      Job(
        id: '1',
        title: 'Content Writer',
        company: 'BlogSpot',
        salary: '500.000 - 800.000',
        type: ['Remote', 'Part-time', 'Project'],
      ),
      Job(
        id: '2',
        title: 'Social Media Post Designer',
        company: 'CreativeHub',
        salary: '750.000 - 1.200.000',
        type: ['Remote', 'Freelance', 'Project'],
      ),
      Job(
        id: '3',
        title: 'Data Entry Specialist',
        company: 'DataFlow',
        salary: '400.000 - 600.000',
        type: ['Remote', 'Part-time', 'Weekly'],
      ),
      Job(
        id: '4',
        title: 'Virtual Assistant',
        company: 'Assist.me',
        salary: '800.000 - 1.500.000',
        type: ['Remote', 'Flexible', 'Monthly'],
      ),
      Job(
        id: '5',
        title: 'Logo Designer',
        company: 'ArtCraft',
        salary: '1.000.000 - 2.000.000',
        type: ['Remote', 'Freelance', 'Project'],
      ),
      Job(
        id: '6',
        title: 'Translation Services',
        company: 'LangBridge',
        salary: '500.000 - 1.000.000',
        type: ['Remote', 'Flexible', 'Project'],
      ),
      Job(
        id: '7',
        title: 'Video Editor',
        company: 'ViewTube',
        salary: '800.000 - 1.500.000',
        type: ['Remote', 'Project', 'Freelance'],
      ),
      Job(
        id: '8',
        title: 'Transcriptionist',
        company: 'AudioText',
        salary: '400.000 - 800.000',
        type: ['Remote', 'Flexible', 'Project'],
      ),
      Job(
        id: '9',
        title: 'Website Tester',
        company: 'TestPro',
        salary: '300.000 - 500.000',
        type: ['Remote', 'Part-time', 'Weekly'],
      ),
      Job(
        id: '10',
        title: 'Survey Participant',
        company: 'SurveyHub',
        salary: '200.000 - 400.000',
        type: ['Remote', 'Flexible', 'Project'],
      ),
      Job(
        id: '11',
        title: 'Poster Designer',
        company: 'DesignLab',
        salary: '600.000 - 1.000.000',
        type: ['Remote', 'Freelance', 'Project'],
      ),
      Job(
        id: '12',
        title: 'Resume Writer',
        company: 'CareerBoost',
        salary: '500.000 - 800.000',
        type: ['Remote', 'Flexible', 'Project'],
      ),
      Job(
        id: '13',
        title: 'Proofreader',
        company: 'TextPerfect',
        salary: '400.000 - 700.000',
        type: ['Remote', 'Part-time', 'Project'],
      ),
      Job(
        id: '14',
        title: 'Social Media Manager',
        company: 'SocialPro',
        salary: '1.000.000 - 1.800.000',
        type: ['Remote', 'Part-time', 'Monthly'],
      ),
      Job(
        id: '15',
        title: 'Photography Editor',
        company: 'PixelPro',
        salary: '600.000 - 1.200.000',
        type: ['Remote', 'Freelance', 'Project'],
      ),
    ]);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Analyzer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage('assets/illustrations.png'),
            fit: BoxFit.contain,
            alignment: Alignment.topCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Hey Brian, Welcome!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                // Buttons Grid
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [
                    _buildButton('Mood Analyzer', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MoodAnalyzerHome(),
                        ),
                      );
                    }),
                    _buildButton('Self Analyzer', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Self1(),
                        ),
                      );
                    }),
                    _buildButton('Quick Work', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuickWorkHomeScreen(),
                        ),
                      );
                    }),
                    _buildButton('Community\nSupport', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CommunityScreen(),
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return Container(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
