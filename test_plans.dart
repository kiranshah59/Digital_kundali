import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  final url = Uri.parse('http://192.168.1.72:8000/api/plans');
  try {
    final response = await http.get(url);
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
  } catch (e) {
    print('Error: $e');
  }
}
