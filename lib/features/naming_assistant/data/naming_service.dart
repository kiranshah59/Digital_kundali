import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../auth/data/auth_service.dart';

class NamingService {
  static const String baseUrl = 'https://api.digitalkundali.com/api';

  static Future<Map<String, String>> _getHeaders() async {
    final token = AuthService.token;
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, dynamic>> getNamingSuggestionsForProfile(String profileId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/birth-profiles/$profileId/naming-suggestion'),
        headers: await _getHeaders(),
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {'success': true, 'data': data, 'statusCode': 200};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get naming suggestions',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {'success': false, 'message': e.toString(), 'statusCode': 500};
    }
  }

  static Future<Map<String, dynamic>> getMoreNamingSuggestions({
    required String startingSound,
    String? gender,
    String? origin,
    int page = 1,
  }) async {
    try {
      final queryParams = <String, String>{
        'starting_sound': startingSound,
        'page': page.toString(),
      };
      
      if (gender != null && gender.isNotEmpty) queryParams['gender'] = gender;
      if (origin != null && origin.isNotEmpty) queryParams['origin'] = origin;

      final uri = Uri.parse('$baseUrl/naming-suggestions').replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: await _getHeaders(),
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {'success': true, 'data': data, 'statusCode': 200};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get more naming suggestions',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {'success': false, 'message': e.toString(), 'statusCode': 500};
    }
  }

  static Future<Map<String, dynamic>> generateMoreNamingSuggestions({
    required String startingSound,
    String? gender,
    String? origin,
  }) async {
    try {
      final body = <String, dynamic>{
        'starting_sound': startingSound,
      };
      
      if (gender != null && gender.isNotEmpty) body['gender'] = gender;
      if (origin != null && origin.isNotEmpty) body['origin'] = origin;

      final response = await http.post(
        Uri.parse('$baseUrl/naming-suggestions/generate-more'),
        headers: await _getHeaders(),
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': data, 'statusCode': response.statusCode};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to generate more names',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {'success': false, 'message': e.toString(), 'statusCode': 500};
    }
  }

  static Future<Map<String, dynamic>> postReaction(String babyNameId, String reaction) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/baby-names/$babyNameId/reaction'),
        headers: await _getHeaders(),
        body: jsonEncode({'reaction': reaction}), // 'like' or 'dislike'
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'statusCode': response.statusCode};
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to post reaction',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {'success': false, 'message': e.toString(), 'statusCode': 500};
    }
  }

  static Future<Map<String, dynamic>> deleteReaction(String babyNameId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/baby-names/$babyNameId/reaction'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return {'success': true, 'statusCode': response.statusCode};
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to delete reaction',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {'success': false, 'message': e.toString(), 'statusCode': 500};
    }
  }
}
