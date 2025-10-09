import 'dart:convert';
import 'package:http/http.dart' as http;

const baseUrl = "https://adso711-sisrel-94jo.onrender.com";

class AuthService {
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('Datos a enviar:');
      print('Email: $email');
      print('Password: $password');
      
      final payload = {
        'email': email.toLowerCase(), // Aseguramos email en minúsculas
        'password': password
      };
      
      print('Payload: ${jsonEncode(payload)}');

      final response = await http.post(
        Uri.parse('${baseUrl}/api/v1/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(payload),
      );

      print('Status Code: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return {
          'success': true,
          'data': jsonResponse['data'],
          'message': jsonResponse['message']
        };
      } else {
        final jsonResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': jsonResponse['message'] ?? 'Error al iniciar sesión'
        };
      }
    } catch (e) {
      print('Error de conexión: $e');
      return {
        'success': false,
        'message': 'Error de conexión: ${e.toString()}'
      };
    }
  }

  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );
    return emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= 5;
  }
}