import 'package:http/http.dart' as http;
import 'dart:convert';
import 'lib/features/auth/data/auth_service.dart';

void main() async {
  final url = Uri.parse('https://api.digitalkundali.com/api/payments/esewa/initiate');
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'plan_id': 2}),
    );
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
  } catch (e) {
    print('Error: $e');
  }
}
