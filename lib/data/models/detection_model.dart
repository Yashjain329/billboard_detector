class DetectionResult {
  final String label;
  final double confidence;
  final Map<String, dynamic>? extra;

  DetectionResult({
    required this.label,
    required this.confidence,
    this.extra,
  });

  factory DetectionResult.fromJson(Map<String, dynamic> json) {
    return DetectionResult(
      label: json['label'] ?? 'Unknown',
      confidence: (json['confidence'] ?? 0).toDouble(),
      extra: json,
    );
  }
}


class DetectionModel {
  final String? className;
  final double? confidence;
  final double? boundingBoxX;
  final double? boundingBoxY;
  final double? boundingBoxWidth;
  final double? boundingBoxHeight;
  final String? detectedText;
  final DateTime? createdAt;

  DetectionModel({
    this.className,
    this.confidence,
    this.boundingBoxX,
    this.boundingBoxY,
    this.boundingBoxWidth,
    this.boundingBoxHeight,
    this.detectedText,
    this.createdAt,
  });

  factory DetectionModel.fromJson(Map<String, dynamic> json) {
    return DetectionModel(
      className: json['class_name'],
      confidence: (json['confidence'] as num?)?.toDouble(),
      boundingBoxX: (json['bbox_x'] as num?)?.toDouble(),
      boundingBoxY: (json['bbox_y'] as num?)?.toDouble(),
      boundingBoxWidth: (json['bbox_w'] as num?)?.toDouble(),
      boundingBoxHeight: (json['bbox_h'] as num?)?.toDouble(),
      detectedText: json['detected_text'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class_name': className,
      'confidence': confidence,
      'bbox_x': boundingBoxX,
      'bbox_y': boundingBoxY,
      'bbox_w': boundingBoxWidth,
      'bbox_h': boundingBoxHeight,
      'detected_text': detectedText,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
