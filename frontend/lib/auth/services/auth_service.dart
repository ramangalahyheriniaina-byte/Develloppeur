import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_response.dart';

class AuthService {
  // Flutter web => localhost OK
  static const String baseUrl = 'http://localhost:3000/api/auth';

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return LoginResponse.fromJson(data);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Erreur login');
    }
  }
}
