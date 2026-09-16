import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chart_model.dart';
import '../models/nepali_kundali_model.dart';
import '../models/insight_model.dart';
import '../../auth/data/auth_service.dart';

class ChartService {
  static const String baseUrl = 'https://api.digitalkundali.com/api';

  static Future<Map<String, dynamic>> getChart(int profileId) async {
    final url = Uri.parse('$baseUrl/birth-profiles/$profileId/chart');
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
          'data': ChartModel.fromJson(decodedData['data']),
        };
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'statusCode': 404,
          'message': decodedData['message'] ?? 'Chart not found',
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'statusCode': 401,
          'message': 'Session expired. Please log in again.',
        };
      } else {
        return {
          'success': false,
          'message': decodedData['message'] ?? 'Failed to load chart',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> generateChart(int profileId) async {
    final url = Uri.parse('$baseUrl/birth-profiles/$profileId/chart');
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
          )
          .timeout(const Duration(seconds: 30));

      final decodedData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'data': ChartModel.fromJson(decodedData['data']),
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'statusCode': 401,
          'message': 'Session expired. Please log in again.',
        };
      } else {
        return {
          'success': false,
          'message': decodedData['message'] ?? 'Failed to generate chart',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> getNepaliKundali(int chartId) async {
    final url = Uri.parse('$baseUrl/charts/$chartId/kundali/nepali');
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
          'data': NepaliKundaliModel.fromJson(decodedData['data']),
          'statusCode': response.statusCode,
        };
      } else {
        return {
          'success': false,
          'message': decodedData['message'] ?? 'Failed to load Nepali Kundali',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
        'statusCode': 500,
      };
    }
  }

  // --- INSIGHTS ---

  static Future<Map<String, dynamic>> getInsight(
    int chartId,
    String topicSlug, {
    String language = 'en',
    String style = 'technical',
  }) async {
    final url = Uri.parse(
      '$baseUrl/charts/$chartId/insights/$topicSlug?language=$language&style=$style',
    );
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
          'data': InsightModel.fromJson(decodedData['data']),
          'statusCode': response.statusCode,
        };
      } else {
        return {
          'success': false,
          'message': decodedData['message'] ?? 'Failed to load insight',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
        'statusCode': 500,
      };
    }
  }

  static Future<Map<String, dynamic>> regenerateInsight(
    int chartId,
    String topicSlug, {
    String language = 'en',
    String style = 'technical',
  }) async {
    final url = Uri.parse(
      '$baseUrl/charts/$chartId/insights/$topicSlug/regenerate?language=$language&style=$style',
    );
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
          )
          .timeout(const Duration(seconds: 30));

      final decodedData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'data': InsightModel.fromJson(decodedData['data']),
          'statusCode': response.statusCode,
        };
      } else {
        return {
          'success': false,
          'message': decodedData['message'] ?? 'Failed to regenerate insight',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
        'statusCode': 500,
      };
    }
  }

  static Future<Map<String, dynamic>> getDasha(
    int profileId, {
    String language = 'en',
    String style = 'technical',
  }) async {
    final url = Uri.parse(
      '$baseUrl/birth-profiles/$profileId/dasha?language=$language&style=$style',
    );
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
          'data': decodedData,
        };
      } else {
        return {
          'success': false,
          'message': decodedData['message'] ?? 'Failed to load dasha',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> getInsightTopics() async {
    final url = Uri.parse('$baseUrl/insight-topics');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (AuthService.token != null) 'Authorization': 'Bearer ${AuthService.token}',
        },
      ).timeout(const Duration(seconds: 30));

      final decodedData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'data': decodedData['data'], // Assume it returns a list in data
        };
      } else {
        return {
          'success': false,
          'message': decodedData['message'] ?? 'Failed to load insight topics',
        };
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getDailyPrediction(
    String rashiSlug, {
    String language = 'en',
    String style = 'technical',
  }) async {
    final url = Uri.parse(
      '$baseUrl/rashis/$rashiSlug/predictions?period=daily&language=$language&style=$style',
    );
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (AuthService.token != null) 'Authorization': 'Bearer ${AuthService.token}',
        },
      ).timeout(const Duration(seconds: 30));

      final decodedData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'data': decodedData['data'],
        };
      } else {
        return {
          'success': false,
          'message': decodedData['message'] ?? 'Failed to load daily prediction',
        };
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
