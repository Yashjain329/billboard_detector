class ViolationModel {
  final String? violationType;
  final String? severity;
  final String? description;
  final String? status;
  final DateTime? createdAt;

  ViolationModel({
    this.violationType,
    this.severity,
    this.description,
    this.status,
    this.createdAt,
  });

  factory ViolationModel.fromJson(Map<String, dynamic> json) {
    return ViolationModel(
      violationType: json['violation_type'],
      severity: json['severity'],
      description: json['description'],
      status: json['status'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'violation_type': violationType,
      'severity': severity,
      'description': description,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}