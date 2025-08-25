import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:billboard_detector/data/models/detection_model.dart';
import 'package:billboard_detector/data/models/violation_model.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;
  // ------------------- AUTH -------------------
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    String? fullName,
  }) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
      data: fullName != null ? {'full_name': fullName} : null,
    );
    return response;
  }

  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> resetPassword({required String email}) async {
    await supabase.auth.resetPasswordForEmail(email);
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
  // ------------------- DETECTIONS -------------------
  Future<List<DetectionModel>> getDetections() async {
    final response = await supabase.from('detections').select();
    return (response as List)
        .map((e) => DetectionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> insertDetection(DetectionModel? detection) async {
    if (detection == null) return;
    await supabase.from('detections').insert(detection.toJson());
  }

  // ------------------- VIOLATIONS -------------------
  Future<List<ViolationModel>> getViolations() async {
    final response = await supabase.from('violations').select();
    return (response as List)
        .map((e) => ViolationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> insertViolation(ViolationModel? violation) async {
    if (violation == null) return;
    await supabase.from('violations').insert(violation.toJson());
  }

  // ------------------- STATS (for HomeScreen) -------------------
  Future<Map<String, dynamic>> getDetectionStats() async {
    final response =
    await supabase.rpc('get_detection_stats'); // requires Postgres function
    return response as Map<String, dynamic>;
  }
}
