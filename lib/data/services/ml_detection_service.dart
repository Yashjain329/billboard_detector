import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class MLDetectionService {
  // 🔹 Change this depending on where you run the container:
  // - Android Emulator: http://10.0.2.2:8000
  // - iOS Simulator: http://localhost:8000
  // - Real Device: http://<your-computer-LAN-IP>:8000
  final String baseUrl = "http://10.0.2.2:8000";

  Future<Map<String, dynamic>> detectImage(String imagePath) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/detect'),
    );

    request.files.add(await http.MultipartFile.fromPath(
      'file',
      imagePath,
      contentType: MediaType('image', 'jpeg'),
    ));

    var response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr);
    } else {
      throw Exception("Detection failed: ${response.statusCode}");
    }
  }
}