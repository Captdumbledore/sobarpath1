import 'package:flutter/material.dart';
import 'package:combined_app/games/whack_a_doggo.dart'; // Import Whack-a-Doggo game
import 'package:combined_app/games/swappy_doggo.dart'; // Import Swappy Doggo game
import 'package:just_audio/just_audio.dart';
import 'package:combined_app/services/audio_provider.dart';

// Add this class at the top of the file
class AudioPlayerProvider extends ChangeNotifier {
  static final AudioPlayerProvider _instance = AudioPlayerProvider._internal();
  factory AudioPlayerProvider() => _instance;
  AudioPlayerProvider._internal() {
    // Add listener to sync UI with actual playback state
    audioPlayer.playerStateStream.listen((state) {
      setPlaying(state.playing);
    });
  }

  final AudioPlayer audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  void setPlaying(bool value) {
    if (_isPlaying != value) {
      _isPlaying = value;
      notifyListeners();
    }
  }

  Future<void> togglePlayPause() async {
    try {
      if (_isPlaying) {
        await audioPlayer.pause();
      } else {
        await audioPlayer.play();
      }
    } catch (e) {
      debugPrint('Error toggling audio: $e');
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  // Add volume control
  Future<void> setVolume(double volume) async {
    try {
      await audioPlayer.setVolume(volume);
    } catch (e) {
      debugPrint('Error setting volume: $e');
    }
  }

  // Add method to lower volume during games
  Future<void> enterGame() async {
    if (_isPlaying) {
      await setVolume(0.3); // Lower volume during game
    }
  }

  // Add method to restore volume after games
  Future<void> exitGame() async {
    if (_isPlaying) {
      await setVolume(1.0); // Restore normal volume
    }
  }
}

// Add this class at the top level of the file
class GameWrapper extends StatelessWidget {
  final Widget child;
  const GameWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          AudioControlButton(),
          const SizedBox(width: 16),
        ],
      ),
      body: child,
    );
  }
}

// Starting page (Page 1)
class MoodAnalyzerHome extends StatelessWidget {
  const MoodAnalyzerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/confused_dog_2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const Text(
                'Feeling %&### ??',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Lets find out by answering the survey!!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuestionairePage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                child: const Text(
                  'Start Survey',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

// Questionnaire page (Page 2)
class QuestionairePage extends StatefulWidget {
  const QuestionairePage({super.key});

  @override
  State<QuestionairePage> createState() => _QuestionairePageState();
}

class _QuestionairePageState extends State<QuestionairePage> {
  int currentQuestionIndex = 0;
  List<int> answers = List.filled(10, -1); // Store answers for each question

  final List<String> questions = [
    'Do you feel calm and at peace right now?',
    'Do you feel tense or anxious at the moment?',
    'Do you feel happy or content in this moment?',
    'Do you feel irritated or annoyed by something currently?',
    'Do you feel lonely right now, even if others are around?',
    'Do you feel motivated to take on tasks or activities at this moment?',
    'Do you feel overwhelmed or stressed about something right now?',
    'Do you feel hopeful or positive about your immediate future?',
    'Do you feel emotionally drained or tired right now?',
    'Do you feel connected or supported by people around you currently?',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              questions[currentQuestionIndex],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                9,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      answers[currentQuestionIndex] = index;
                    });
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue),
                      color: answers[currentQuestionIndex] == index
                          ? Colors.blue
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Very Unlikely'),
                const Text('Neutral'),
                const Text('Very Likely'),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                if (answers[currentQuestionIndex] == -1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select an answer'),
                    ),
                  );
                  return;
                }

                if (currentQuestionIndex < questions.length - 1) {
                  setState(() {
                    currentQuestionIndex++;
                  });
                } else {
                  // Calculate mood and navigate to result page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MoodResultPage(answers: answers),
                    ),
                  );
                }
              },
              child: Text(
                currentQuestionIndex < questions.length - 1 ? 'Next' : 'Finish',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Result page (Page 4)
class MoodResultPage extends StatefulWidget {
  final List<int> answers;

  const MoodResultPage({super.key, required this.answers});

  @override
  State<MoodResultPage> createState() => _MoodResultPageState();
}

class _MoodResultPageState extends State<MoodResultPage> {
  final audioProvider = AudioPlayerProvider();
  String mood = '';

  @override
  void initState() {
    super.initState();
    mood = calculateMood();
    _setupAudio();

    // Show toast after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Playing ${mood.toLowerCase()} mood music 🎵'),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    });
  }

  Future<void> _setupAudio() async {
    try {
      String audioFile;
      switch (mood) {
        case 'Happy':
          audioFile = 'assets/audio/happiness.mp3';
          break;
        case 'Neutral':
          audioFile = 'assets/audio/neutral.mp3';
          break;
        case 'Sad':
          audioFile = 'assets/audio/stress.mp3';
          break;
        default:
          audioFile = 'assets/audio/neutral.mp3';
      }

      await audioProvider.audioPlayer.setAsset(audioFile);
      audioProvider.setPlaying(true);
      await audioProvider.audioPlayer.play();
    } catch (e) {
      debugPrint('Error playing audio: $e');
      audioProvider.setPlaying(false);
    }
  }

  String calculateMood() {
    // Questions indices that represent negative feelings
    // When these questions get high scores, they should count negatively
    final negativeQuestions = [1, 3, 4, 6, 8]; // indices of negative questions

    double total = 0;

    for (int i = 0; i < widget.answers.length; i++) {
      if (negativeQuestions.contains(i)) {
        // For negative questions, reverse the score (8 - answer)
        // Since answer range is 0-8, this will invert the score
        total += (8 - widget.answers[i]);
      } else {
        // For positive questions, use the score as is
        total += widget.answers[i];
      }
    }

    // Calculate average (still on 0-8 scale)
    double average = total / widget.answers.length;

    // Determine mood based on adjusted average
    if (average < 3.5) return 'Sad';
    if (average < 5.5) return 'Neutral';
    return 'Happy';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          AudioControlButton(),
          const SizedBox(width: 16),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/survey4.png'.toLowerCase()),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Text(
                'You Feeling $mood....',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                mood == 'Happy'
                    ? 'Thats really great to feel happy, lets play some games'
                    : mood == 'Neutral'
                        ? 'Thats alright, lets elevate your mood'
                        : 'Lets fix this together....!!',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GamesPage(),
                    ),
                  );
                },
                child: const Text("Let's Play some Games"),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

// Add this new widget
class AudioControlButton extends StatefulWidget {
  const AudioControlButton({super.key});

  @override
  State<AudioControlButton> createState() => _AudioControlButtonState();
}

class _AudioControlButtonState extends State<AudioControlButton> {
  final audioProvider = AudioPlayerProvider();

  @override
  void initState() {
    super.initState();
    audioProvider.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        audioProvider.isPlaying
            ? Icons.pause_circle_filled
            : Icons.play_circle_filled,
        color: Colors.black87,
        size: 48,
      ),
      iconSize: 48,
      padding: const EdgeInsets.all(8),
      onPressed: () => audioProvider.togglePlayPause(),
    );
  }

  @override
  void dispose() {
    audioProvider.removeListener(() {});
    super.dispose();
  }
}

// Games page (Page 5)
class GamesPage extends StatefulWidget {
  const GamesPage({super.key});

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  final audioProvider = AudioPlayerProvider();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            AudioControlButton(),
            const SizedBox(width: 16),
          ],
        ),
        body: Container(
          color: Colors.lightBlue[100],
          child: Column(
            children: [
              const SizedBox(height: 40),
              Image.asset(
                'assets/images/flying_dog.png',
                height: 150,
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(20),
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameWrapper(
                              child: WhackADoggo(),
                            ),
                          ),
                        );
                      },
                      child: const Text('Whack-a-Doggo'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameWrapper(
                              child: FlappyBird(),
                            ),
                          ),
                        );
                      },
                      child: const Text('Flappy Bird'),
                    ),
                    const GameCard(
                      isComingSoon: true,
                    ),
                    const GameCard(
                      isComingSoon: true,
                    ),
                    const GameCard(
                      isComingSoon: true,
                    ),
                    const GameCard(
                      isComingSoon: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String? image;
  final bool isComingSoon;

  const GameCard({
    super.key,
    this.image,
    required this.isComingSoon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: isComingSoon
          ? const Center(
              child: Text(
                'Coming\nsoon',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Image.asset(
              image!,
              fit: BoxFit.cover,
            ),
    );
  }
}
