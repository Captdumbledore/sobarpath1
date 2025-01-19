import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerProvider extends ChangeNotifier {
  static final AudioPlayerProvider _instance = AudioPlayerProvider._internal();
  factory AudioPlayerProvider() => _instance;

  AudioPlayerProvider._internal() {
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

  Future<void> setVolume(double volume) async {
    try {
      await audioPlayer.setVolume(volume);
    } catch (e) {
      debugPrint('Error setting volume: $e');
    }
  }

  Future<void> enterGame() async {
    if (_isPlaying) {
      await setVolume(0.3);
    }
  }

  Future<void> exitGame() async {
    if (_isPlaying) {
      await setVolume(1.0);
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
