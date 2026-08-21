import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final baseUrl = 'https://api.digitalkundali.com/api';
  final url = Uri.parse('$baseUrl/auth/login');
  
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode({
      'email': 'shahkiran7777@gmail.com',
      'password': 'password123',
    }),
  );
  
  print('Status: ${response.statusCode}');
  print('Body: ${response.body}');
}
