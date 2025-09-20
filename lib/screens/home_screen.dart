import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:vector_math/vector_math_64.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String generatedText = "";
  Object? model3D;
  AudioPlayer? _audioPlayer;
  final TextEditingController _promptController = TextEditingController();
  bool isLoading = false;

  Future<void> generateText() async {
    setState(() {
      isLoading = true;
      generatedText = "";
    });

    await Future.delayed(const Duration(seconds: 1)); // simulate API call
    generatedText = "AI generated text for: ${_promptController.text}";

    setState(() => isLoading = false);
  }

  Future<void> playVoice() async {
    if (generatedText.isEmpty) return;
    _audioPlayer?.dispose();
    _audioPlayer = AudioPlayer();
    await _audioPlayer!.play(AssetSource("audio/test.mp3")); // local audio
  }

  Future<void> generate3D() async {
    setState(() {
      model3D = Object(
        fileName: "assets/cube/cube.obj",
        scale: Vector3(2.0, 2.0, 2.0),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Studio")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                labelText: "Enter prompt",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: generateText, child: const Text("Text")),
                ElevatedButton(
                    onPressed: playVoice, child: const Text("Voice")),
                ElevatedButton(onPressed: generate3D, child: const Text("3D")),
              ],
            ),

            const SizedBox(height: 20),

            // Results area
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        if (generatedText.isNotEmpty)
                          Text(generatedText,
                              style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 20),
                        if (model3D != null)
                          Expanded(
                            child: Cube(
                              onSceneCreated: (scene) {
                                scene.world.add(model3D!);
                                scene.camera.zoom = 10;
                              },
                            ),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
