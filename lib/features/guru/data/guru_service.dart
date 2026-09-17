import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../auth/data/auth_service.dart';
import '../models/guru_message_model.dart';
import '../models/guru_quota_model.dart';

class GuruService {
  static const String baseUrl = 'https://api.digitalkundali.com/api';

  static Future<Map<String, dynamic>> getGuruChatQuota() async {
    final url = Uri.parse('$baseUrl/guru-chat-quota');
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
        var payload = decodedData['data'] ?? decodedData;
        if (payload is Map<String, dynamic> && payload.containsKey('data')) {
          payload = payload['data'];
        }
        return {
          'success': true,
          'data': GuruQuotaModel.fromJson(payload),
        };
      } else {
        return {
          'success': false,
          'message': decodedData['message'] ?? 'Failed to load quota',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> getGuruChatHistory(int profileId) async {
    final url = Uri.parse('$baseUrl/birth-profiles/$profileId/guru-chat');
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
        final List<dynamic> historyData = decodedData['data'] ?? decodedData;
        final List<GuruMessageModel> messages = historyData
            .map((e) => GuruMessageModel.fromJson(e))
            .toList();

        return {
          'success': true,
          'data': messages,
        };
      } else if (response.statusCode == 403) {
        return {
          'success': false,
          'message': 'Not authorized to view this chat history',
          'statusCode': 403,
        };
      } else {
        return {
          'success': false,
          'message': decodedData['message'] ?? 'Failed to load chat history',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> sendGuruChatMessage(
    int profileId,
    String message, {
    String language = 'en',
  }) async {
    final url = Uri.parse('$baseUrl/birth-profiles/$profileId/guru-chat');
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
            body: jsonEncode({
              'message': message,
              'language': language,
            }),
          )
          .timeout(const Duration(seconds: 120)); // Long timeout for AI response

      final decodedData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final payload = decodedData['data'] ?? decodedData;
        return {
          'success': true,
          'data': GuruMessageModel.fromJson(payload),
        };
      } else if (response.statusCode == 429) {
        return {
          'success': false,
          'statusCode': 429,
          'message': decodedData['message'] ?? 'You have reached this month\'s Guru chat message limit.',
        };
      } else if (response.statusCode == 402) {
        return {
          'success': false,
          'statusCode': 402,
          'message': decodedData['message'] ?? 'You have used your free Guru chat messages. Upgrade to continue.',
        };
      } else {
        return {
          'success': false,
          'message': decodedData['message'] ?? 'Failed to send message',
          'statusCode': response.statusCode,
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
