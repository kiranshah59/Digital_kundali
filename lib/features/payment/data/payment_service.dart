import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../auth/data/auth_service.dart';

class PaymentService {
  // Use the same base URL as other services
  static const String baseUrl = 'https://api.digitalkundali.com/api';

  static Future<Map<String, dynamic>> getPlans() async {
    final url = Uri.parse('https://api.digitalkundali.com/api/plans'); // Hardcoding to match existing format or dynamically get it

    try {
      final response = await http
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              if (AuthService.token != null)
                'Authorization': 'Bearer ${AuthService.token}',
            },
          )
          .timeout(const Duration(seconds: 30));

      final decodedData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'data': decodedData['data'] ?? decodedData, // Handle wrapper if any
        };
      } else {
        return {
          'success': false,
          'statusCode': response.statusCode,
          'message': decodedData['message'] ?? 'Failed to load plans',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> initiateEsewaPayment({int planId = 2}) async {
    final url = Uri.parse('$baseUrl/payments/esewa/initiate');

    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              if (AuthService.token != null)
                'Authorization': 'Bearer ${AuthService.token}',
            },
            body: jsonEncode({'plan_id': planId}),
          )
          .timeout(const Duration(seconds: 30));

      final decodedData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = decodedData['data'] ?? decodedData;
        return {
          'success': true,
          'action_url': data['action_url'],
          'fields': data['fields'],
        };
      } else {
        return {
          'success': false,
          'statusCode': response.statusCode,
          'message': decodedData['message'] ?? 'Failed to initiate payment',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
}
