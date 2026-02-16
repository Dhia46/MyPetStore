import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = 'http://localhost:8000';
  static String? sessionId;

  Future<bool> login(String u, String p) async {
    final r = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': u, 'password': p}),
    );

    if (r.statusCode == 200) {
      sessionId = jsonDecode(r.body)['session_id'];
      return true;
    }
    return false;
  }

  // 🔥 CORRIGÉ ICI
  Future<Map<String, dynamic>> register(String u, String c, String p) async {
    final r = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': u, 'cin': c, 'password': p}),
    );

    final data = jsonDecode(r.body);

    if (r.statusCode == 200) {
      sessionId = data['session_id'];
      return {'success': true, 'message': data['message']};
    } else {
      return {'success': false, 'message': data['detail'] ?? 'Erreur'};
    }
  }

  Future<List> getPets() async {
    final r = await http.get(Uri.parse('$baseUrl/pets'));
    return jsonDecode(r.body);
  }

  Future<Map<String, dynamic>> getPetDetail(int id) async {
    final r = await http.get(Uri.parse('$baseUrl/pets/$id'));
    return jsonDecode(r.body);
  }

  Future<bool> addPet(Map<String, dynamic> data) async {
    final r = await http.post(
      Uri.parse('$baseUrl/pets'),
      headers: {
        'Content-Type': 'application/json',
        'session-id': sessionId ?? ''
      },
      body: jsonEncode(data),
    );
    return r.statusCode == 200;
  }

  Future<bool> buyPet(int id) async {
    final r = await http.delete(
      Uri.parse('$baseUrl/pets/$id'),
      headers: {'session-id': sessionId ?? ''},
    );
    return r.statusCode == 200;
  }
}
