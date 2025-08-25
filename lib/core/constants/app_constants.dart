import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String get appName => dotenv.env['APP_NAME'] ?? 'Billboard Detector';
  static String get appVersion => dotenv.env['APP_VERSION'] ?? '1.0.0';
  static bool get debugMode => dotenv.env['DEBUG_MODE']?.toLowerCase() == 'true';
  static double get confidenceThreshold => double.tryParse(dotenv.env['CONFIDENCE_THRESHOLD'] ?? '0.5') ?? 0.5;
  static double get iouThreshold => double.tryParse(dotenv.env['IOU_THRESHOLD'] ?? '0.4') ?? 0.4;
  static const String networkError = 'Network connection error. Please check your internet connection.';
  static const String unknownError = 'An unknown error occurred. Please try again.';
  static const String permissionDeniedError = 'Permission denied. Please grant the required permissions.';
}