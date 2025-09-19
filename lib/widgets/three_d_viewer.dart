import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ThreeDViewer extends StatelessWidget {
  final String modelUrl;
  const ThreeDViewer({super.key, required this.modelUrl});

  @override
  Widget build(BuildContext context) {
    return ModelViewer(
      src: modelUrl,
      alt: "3D model",
      autoRotate: true,
      cameraControls: true,
      backgroundColor: Colors.grey.shade200, // ← Fixed nullable issue
    );
  }
}
