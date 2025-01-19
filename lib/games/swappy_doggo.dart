import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:combined_app/services/audio_provider.dart';

class FlappyBird extends StatefulWidget {
  @override
  State<FlappyBird> createState() => _FlappyBirdState();
}

class _FlappyBirdState extends State<FlappyBird> {
  final audioProvider = AudioPlayerProvider();

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

  static double birdY = 0;
  double initialPos = birdY;
  double height = 0;
  double time = 0;
  double gravity = 2.5;
  double velocity = 1.5;
  double birdWidth = 0.1;
  double birdHeight = 0.1;

  bool gameHasStarted = false;
  bool isGameOver = false;
  int score = 0;
  int highscore = 0;
  static double barrierWidth = 0.3;
  static List<double> barrierX = [2, 3.4, 4.8];
  static double barrierMovement = 0.025;
  static double gapSize = 0.5;
  Timer? gameTimer;

  List<List<double>> barrierHeight = [
    [0.6, 0.4],
    [0.4, 0.6],
    [0.5, 0.5],
  ];

  bool checkCollision(int index) {
    if (barrierX[index] <= 0.2 && barrierX[index] + barrierWidth >= -0.2) {
      double topBarrierBottom = -1 + barrierHeight[index][0] * 2;
      double bottomBarrierTop = 1 - barrierHeight[index][1] * 2;
      double birdTopY = birdY - birdHeight / 2;
      double birdBottomY = birdY + birdHeight / 2;

      if (birdTopY <= topBarrierBottom || birdBottomY >= bottomBarrierTop) {
        return true;
      }
    }
    return false;
  }

  void startGame() {
    if (gameHasStarted) return;
    setState(() {
      gameHasStarted = true;
      isGameOver = false;
      score = 0;
      barrierX = [2, 3.4, 4.8];
      birdY = 0;
      initialPos = birdY;
      time = 0;
    });

    gameTimer?.cancel();
    gameTimer = Timer.periodic(Duration(milliseconds: 60), (timer) {
      if (!mounted || isGameOver) {
        timer.cancel();
        return;
      }
      setState(() {
        height = gravity * time * time + velocity * time;
        birdY = initialPos - height;

        if (birdY > 1 || birdY < -1) {
          endGame();
          return;
        }

        bool hasCollided = false;
        for (int i = 0; i < barrierX.length; i++) {
          barrierX[i] -= barrierMovement;

          if (barrierX[i] < -1.5) {
            barrierX[i] += 4.5;
            score++;
            double topHeight = 0.2 + Random().nextDouble() * 0.3;
            barrierHeight[i][0] = topHeight;
            barrierHeight[i][1] = 1 - topHeight - gapSize;
          }

          if (checkCollision(i)) {
            hasCollided = true;
            break;
          }
        }

        if (hasCollided) {
          endGame();
          return;
        }

        time += 0.03;
      });
    });
  }

  void endGame() {
    if (isGameOver) return;
    setState(() {
      isGameOver = true;
      gameHasStarted = false;
    });
    gameTimer?.cancel();
    _showGameOverDialog();
  }

  void moveBirdUp() {
    setState(() {
      birdY -= 0.1;
      if (birdY < -1) birdY = -1;
    });
  }

  void moveBirdDown() {
    setState(() {
      birdY += 0.1;
      if (birdY > 1) birdY = 1;
    });
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      birdY = 0;
      gameHasStarted = false;
      isGameOver = false;
      time = 0;
      initialPos = birdY;
      barrierX = [2, 3.4, 4.8];
      score = 0;
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown,
          title: Center(
            child: Text(
              "G A M E  O V E R",
              style: TextStyle(color: Colors.white),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Score: $score",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(height: 20),
              Text(
                "Best: ${score > highscore ? score : highscore}",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: resetGame,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  padding: EdgeInsets.all(7),
                  color: Colors.white,
                  child: Text(
                    'PLAY AGAIN',
                    style: TextStyle(color: Colors.brown),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            moveBirdUp();
          } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            moveBirdDown();
          }
        }
      },
      child: GestureDetector(
        onTap: gameHasStarted ? moveBirdUp : startGame,
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  color: Colors.blue,
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        alignment: Alignment(0, birdY),
                        duration: Duration(milliseconds: 0),
                        child: Transform.rotate(
                          angle: -velocity * time * 0.3,
                          child: Text(
                            "🐕",
                            style: TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment(0, -0.3),
                        child: Text(
                          gameHasStarted ? '' : 'T A P  T O  P L A Y',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment(0, -0.8),
                        child: Text(
                          score.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      for (int i = 0; i < barrierX.length; i++) ...[
                        AnimatedContainer(
                          alignment: Alignment(barrierX[i], -1.1),
                          duration: Duration(milliseconds: 0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              border: Border.all(width: 2, color: Colors.black),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            width: MediaQuery.of(context).size.width *
                                barrierWidth /
                                2,
                            height: MediaQuery.of(context).size.height *
                                barrierHeight[i][0] /
                                2,
                          ),
                        ),
                        AnimatedContainer(
                          alignment: Alignment(barrierX[i], 1.1),
                          duration: Duration(milliseconds: 0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              border: Border.all(width: 2, color: Colors.black),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            width: MediaQuery.of(context).size.width *
                                barrierWidth /
                                2,
                            height: MediaQuery.of(context).size.height *
                                barrierHeight[i][1] /
                                2,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Container(
                height: 15,
                color: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
