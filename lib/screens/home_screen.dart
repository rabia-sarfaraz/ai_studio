import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:vector_math/vector_math_64.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  AudioPlayer? _audioPlayer;
  bool isLoading = false;
  String generatedText = "";
  Object? model3D;

  final TextEditingController _promptController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index != 1) _disposeAudio();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _disposeAudio();
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _disposeAudio() async {
    if (_audioPlayer != null) {
      await _audioPlayer!.stop();
      await _audioPlayer!.dispose();
      _audioPlayer = null;
    }
  }

  Future<void> generateAll() async {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;

    setState(() => isLoading = true);

    // ---------------- Text ----------------
    await Future.delayed(const Duration(seconds: 1));
    generatedText = "Generated text for: $prompt";

    // ---------------- Voice ----------------
    await _disposeAudio();
    _audioPlayer = AudioPlayer();
    await _audioPlayer!.play(UrlSource(
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3')); // public test mp3

    // ---------------- 3D ----------------
    model3D = Object(
      fileName: 'assets/cube/cube.obj',
      scale: Vector3(2.0, 2.0, 2.0),
    );

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Text / Voice / 3D Generator"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Text"),
            Tab(text: "Voice"),
            Tab(text: "3D"),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promptController,
                    decoration: const InputDecoration(
                        labelText: "Enter your prompt",
                        border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: generateAll,
                  child: const Text("Generate All"),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTextTab(),
                _buildVoiceTab(),
                _build3DTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextTab() {
    return Center(
      child: isLoading
          ? const CircularProgressIndicator()
          : Text(
              generatedText.isEmpty ? "No text yet." : generatedText,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
    );
  }

  Widget _buildVoiceTab() {
    return Center(
      child: isLoading
          ? const CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  generatedText.isEmpty ? "No voice yet." : generatedText,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_audioPlayer != null) {
                      await _disposeAudio();
                      _audioPlayer = AudioPlayer();
                      await _audioPlayer!.play(UrlSource(
                          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'));
                    }
                  },
                  child: const Text("Play Voice Again"),
                ),
              ],
            ),
    );
  }

  Widget _build3DTab() {
    return Center(
      child: isLoading
          ? const CircularProgressIndicator()
          : model3D != null
              ? SizedBox(
                  width: 250,
                  height: 250,
                  child: Cube(
                    interactive: true,
                    onSceneCreated: (scene) {
                      scene.world.add(model3D!);
                      scene.camera.zoom = 10;
                    },
                  ),
                )
              : const Text("No 3D model yet."),
    );
  }
}
