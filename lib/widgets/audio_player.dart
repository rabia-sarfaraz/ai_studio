import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerWidget extends StatefulWidget {
  final Uint8List audioData;
  const AudioPlayerWidget({super.key, required this.audioData});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _player = AudioPlayer();
  bool isPlaying = false;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void togglePlay() async {
    if (isPlaying) {
      await _player.pause();
    } else {
      await _player.play(BytesSource(widget.audioData));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
      onPressed: togglePlay,
    );
  }
}
