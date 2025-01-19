import 'package:flutter/material.dart';
import 'package:combined_app/self_analyzer/gemini_service.dart';

class Self1 extends StatelessWidget {
  const Self1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reflection App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE6E6FA)),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to Self-Analyzer',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE6E6FA),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReflectionPage()),
                  );
                },
                child: const Text(
                  'Start Your Journey',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReflectionPage extends StatefulWidget {
  const ReflectionPage({super.key});

  @override
  State<ReflectionPage> createState() => _ReflectionPageState();
}

class _ReflectionPageState extends State<ReflectionPage> {
  final TextEditingController _thoughtsController = TextEditingController();
  List<String> responses = [];
  int currentQuestionIndex = 0;
  bool showResults = false;

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'How would you rate your energy level today? (1-10)',
      'type': 'slider',
    },
    {
      'question': 'What are your top 3 strengths?',
      'type': 'text',
      'hint': 'Enter your strengths...',
    },
    {
      'question': 'What areas of your life need improvement?',
      'type': 'text',
      'hint': 'Areas for improvement...',
    },
    {
      'question': 'How do you handle stress?',
      'type': 'text',
      'hint': 'Describe your stress management...',
    },
    {
      'question': 'What are your short-term goals?',
      'type': 'text',
      'hint': 'Enter your goals...',
    },
  ];

  double sliderValue = 5.0;

  Widget _buildQuestionWidget() {
    final question = questions[currentQuestionIndex];

    if (question['type'] == 'slider') {
      return Column(
        children: [
          Text(
            question['question'],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Slider(
            value: sliderValue,
            min: 1,
            max: 10,
            divisions: 9,
            label: sliderValue.round().toString(),
            onChanged: (value) {
              setState(() {
                sliderValue = value;
              });
            },
          ),
          Text(
            sliderValue.round().toString(),
            style: const TextStyle(fontSize: 20),
          ),
        ],
      );
    }

    return Column(
      children: [
        Text(
          question['question'],
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _thoughtsController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: question['hint'],
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.grey[100],
          ),
        ),
      ],
    );
  }

  void _nextQuestion() {
    // Validate current response
    if (questions[currentQuestionIndex]['type'] == 'slider') {
      // Slider always has a value, so we can proceed
      setState(() {
        responses.add(sliderValue.round().toString());
      });
    } else {
      // For text input, validate that it's not empty
      if (_thoughtsController.text.trim().isEmpty) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please provide an answer before continuing'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return; // Don't proceed if empty
      }
      setState(() {
        responses.add(_thoughtsController.text);
      });
    }

    setState(() {
      _thoughtsController.clear();

      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        showResults = true;
        _analyzeResponses();
      }
    });
  }

  Future<void> _analyzeResponses() async {
    final geminiService = GeminiService();
    final aiAnalysis = await geminiService.analyzeSelfReflection(responses);

    setState(() {
      analysis = SelfAnalysis(
        energyLevel: int.parse(responses[0]),
        strengths: responses[1],
        areasToImprove: responses[2],
        stressManagement: responses[3],
        goals: responses[4],
        aiAnalysis: aiAnalysis,
      );
    });
  }

  SelfAnalysis? analysis;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Self Analysis'),
        backgroundColor: const Color(0xFFE6E6FA),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: showResults ? _buildResults() : _buildSurvey(),
        ),
      ),
    );
  }

  Widget _buildSurvey() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: _buildQuestionWidget(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE6E6FA),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
          onPressed: _nextQuestion,
          child: Text(
            currentQuestionIndex < questions.length - 1 ? 'Next' : 'Finish',
            style: const TextStyle(fontSize: 18, color: Colors.black87),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          '${currentQuestionIndex + 1}/${questions.length}',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildResults() {
    if (analysis == null)
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFFE6E6FA)),
            SizedBox(height: 20),
            Text('Creating your personalized insights...'),
          ],
        ),
      );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '✨ Your Self-Discovery Journey',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          // Energy Pulse Card
          _buildEnergyCard(analysis!.energyLevel),
          // AI Analysis Card with the main insights
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.psychology, color: Color(0xFFE6E6FA)),
                      SizedBox(width: 8),
                      Text(
                        'Personal Insights',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    analysis!.aiAnalysis,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE6E6FA),
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Begin a New Journey'),
          ),
        ],
      ),
    );
  }

  Widget _buildEnergyCard(int energyLevel) {
    String energyEmoji;
    String energyDescription;

    if (energyLevel >= 8) {
      energyEmoji = '⚡';
      energyDescription = 'You\'re radiating with vibrant energy!';
    } else if (energyLevel >= 6) {
      energyEmoji = '✨';
      energyDescription = 'Your energy is flowing steadily.';
    } else if (energyLevel >= 4) {
      energyEmoji = '🌅';
      energyDescription = 'Your energy is like a gentle sunrise.';
    } else {
      energyEmoji = '🌙';
      energyDescription = 'Your energy is in a restful phase.';
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  energyEmoji,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Energy Pulse',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              energyDescription,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: energyLevel / 10,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                Color(0xFFE6E6FA),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _thoughtsController.dispose();
    super.dispose();
  }
}

class SelfAnalysis {
  final int energyLevel;
  final String strengths;
  final String areasToImprove;
  final String stressManagement;
  final String goals;
  final String aiAnalysis;

  SelfAnalysis({
    required this.energyLevel,
    required this.strengths,
    required this.areasToImprove,
    required this.stressManagement,
    required this.goals,
    this.aiAnalysis = '',
  });
}
