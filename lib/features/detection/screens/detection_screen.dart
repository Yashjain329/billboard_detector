import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:billboard_detector/data/services/ml_detection_service.dart';
import 'package:billboard_detector/data/models/detection_model.dart';

class DetectionScreen extends StatefulWidget {
  const DetectionScreen({super.key});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  final MLDetectionService _service = MLDetectionService();
  DetectionResult? _result;
  bool _loading = false;
  String? _error;
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 85);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _result = null;
        _error = null;
      });
      await _runDetection(pickedFile.path);
    }
  }

  Future<void> _runDetection(String imagePath) async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final data = await _service.detectImage(imagePath);
      setState(() {
        _result = DetectionResult.fromJson(data);
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detection")),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              if (_selectedImage != null)
                Image.file(
                  _selectedImage!,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 20),
              if (_loading) const CircularProgressIndicator(),
              if (_error != null)
                Text("Error: $_error", style: const TextStyle(color: Colors.red)),
              if (_result != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Detected: ${_result!.label}\nConfidence: ${_result!.confidence.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera"),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo),
                    label: const Text("Gallery"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
