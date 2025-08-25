import 'package:flutter/material.dart';
import 'package:billboard_detector/data/models/detection_model.dart';
import 'package:billboard_detector/data/services/supabase_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  List<DetectionModel> _detections = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDetections();
  }

  Future<void> _loadDetections() async {
    final detections = await _supabaseService.getDetections();
    setState(() {
      _detections = detections;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detection History")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _detections.isEmpty
          ? const Center(child: Text("No detections found"))
          : ListView.builder(
        itemCount: _detections.length,
        itemBuilder: (context, index) {
          final detection = _detections[index];
          return Card(
            child: ListTile(
              title: Text(detection.className ?? "Unknown"),
              subtitle: Text(
                "Confidence: ${detection.confidence?.toStringAsFixed(2) ?? "N/A"}\n"
                    "BBox: (${detection.boundingBoxX?.toInt() ?? 0}, "
                    "${detection.boundingBoxY?.toInt() ?? 0}, "
                    "${detection.boundingBoxWidth?.toInt() ?? 0}, "
                    "${detection.boundingBoxHeight?.toInt() ?? 0})",
              ),
              trailing: Text(
                detection.createdAt?.toIso8601String() ?? "",
                style: const TextStyle(fontSize: 12),
              ),
            ),
          );
        },
      ),
    );
  }
}
