import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:combined_app/services/audio_provider.dart';

class WhackADoggo extends StatefulWidget {
  @override
  State<WhackADoggo> createState() => _WhackADoggoState();
}

class _WhackADoggoState extends State<WhackADoggo> {
  final audioProvider = AudioPlayerProvider();
  int score = 0;
  int timeLeft = 30;
  bool isPlaying = false;
  Timer? gameTimer;
  Timer? doggoTimer;
  List<bool> holes = List.generate(9, (_) => false);
  Random random = Random();

  @override
  void initState() {
    super.initState();
    audioProvider.enterGame();
  }

  @override
  void dispose() {
    audioProvider.exitGame();
    super.dispose();
  }

  void startGame() {
    setState(() {
      score = 0;
      timeLeft = 30;
      isPlaying = true;
    });

    gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          endGame();
        }
      });
    });

    doggoTimer = Timer.periodic(Duration(milliseconds: 800), (timer) {
      setState(() {
        holes = List.generate(9, (_) => false);
        int randomIndex = random.nextInt(holes.length);
        holes[randomIndex] = true;
      });
    });
  }

  void endGame() {
    setState(() {
      isPlaying = false;
    });
    gameTimer?.cancel();
    doggoTimer?.cancel();
  }

  void whack(int index) {
    if (isPlaying && holes[index]) {
      setState(() {
        score++;
        holes[index] = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Whack-a-Doggo'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Score: $score', style: TextStyle(fontSize: 24)),
                Text('Time: $timeLeft', style: TextStyle(fontSize: 24)),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: holes.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => whack(index),
                  child: Container(
                    color: holes[index] ? Colors.brown : Colors.green,
                    child: Center(
                      child: holes[index]
                          ? Icon(Icons.pets, size: 50, color: Colors.white)
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
          if (!isPlaying)
            ElevatedButton(
              onPressed: startGame,
              child: Text('Start Game'),
            ),
        ],
      ),
    );
  }
}
