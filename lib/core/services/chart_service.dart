import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/chart_model.dart';
import '../../models/nepali_kundali_model.dart';
import '../../models/insight_model.dart';
import 'auth_service.dart';

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
        // Mock fallback for testing without paid plan
        return {'success': true, 'data': _getMockChart(profileId)};
      }
    } catch (e) {
      // Mock fallback for network error
      return {'success': true, 'data': _getMockChart(profileId)};
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
        // Mock fallback for testing without paid plan
        return {'success': true, 'data': _getMockChart(profileId)};
      }
    } catch (e) {
      // Mock fallback for network error
      return {'success': true, 'data': _getMockChart(profileId)};
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
          .timeout(const Duration(seconds: 1));

      final decodedData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'data': NepaliKundaliModel.fromJson(decodedData['data']),
        };
      } else {
        // Mock fallback for testing without paid plan
        return {'success': true, 'data': _getMockNepali(chartId)};
      }
    } catch (e) {
      // Mock fallback for network error
      return {'success': true, 'data': _getMockNepali(chartId)};
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
          .timeout(const Duration(seconds: 1));

      final decodedData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'data': InsightModel.fromJson(decodedData['data']),
        };
      } else {
        return {
          'success': false,
          'message': decodedData['message'] ?? 'Insight not found',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error'};
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
          .timeout(const Duration(seconds: 1));

      final decodedData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'data': InsightModel.fromJson(decodedData['data']),
        };
      } else {
        return {
          'success': false,
          'message': decodedData['message'] ?? 'Failed to regenerate insight',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error'};
    }
  }

  // --- MOCK DATA FOR TESTING API INTEGRATION LOCALLY ---

  static ChartModel _getMockChart(int profileId) {
    int signOffset = (profileId.toString().hashCode.abs()) % 12;
    List<String> signs = [
      "Aries",
      "Taurus",
      "Gemini",
      "Cancer",
      "Leo",
      "Virgo",
      "Libra",
      "Scorpio",
      "Sagittarius",
      "Capricorn",
      "Aquarius",
      "Pisces",
    ];

    return ChartModel.fromJson({
      "id": profileId,
      "birth_profile_id": profileId,
      "ayanamsa_system": "lahiri",
      "house_system": "whole_sign",
      "chart_data": {
        "ascendant": {
          "sign": signs[signOffset],
          "degree": 12.5,
          "nakshatra": "Ashwini",
          "pada": 1,
        },
        "planets": {
          "sun": {
            "sign": signs[(signOffset + 1) % 12],
            "degree": 14.32,
            "house": 2,
            "nakshatra": "Krittika",
            "pada": 2,
            "retrograde": false,
          },
          "moon": {
            "sign": signs[(signOffset + 2) % 12],
            "degree": 5.2,
            "house": 3,
            "nakshatra": "Mrigashira",
            "pada": 1,
            "retrograde": false,
          },
          "mars": {
            "sign": signs[(signOffset + 3) % 12],
            "degree": 21.1,
            "house": 4,
            "nakshatra": "Punarvasu",
            "pada": 4,
            "retrograde": false,
          },
          "mercury": {
            "sign": signs[(signOffset + 4) % 12],
            "degree": 28.56,
            "house": 5,
            "nakshatra": "Magha",
            "pada": 1,
            "retrograde": false,
          },
          "jupiter": {
            "sign": signs[(signOffset + 5) % 12],
            "degree": 5.12,
            "house": 6,
            "nakshatra": "Chitra",
            "pada": 1,
            "retrograde": false,
          },
          "venus": {
            "sign": signs[(signOffset + 6) % 12],
            "degree": 18.33,
            "house": 7,
            "nakshatra": "Vishakha",
            "pada": 1,
            "retrograde": false,
          },
          "saturn": {
            "sign": signs[(signOffset + 7) % 12],
            "degree": 26.09,
            "house": 8,
            "nakshatra": "Jyeshtha",
            "pada": 1,
            "retrograde": false,
          },
        },
        "houses": List.generate(12, (index) => {
          "house": index + 1,
          "sign": signs[(signOffset + index) % 12],
        }),
        "ayanamsa_value": 24.16,
        "julian_day_ut": 2449823.927,
      },
      "engine_version": "1.0.0",
      "generated_at": DateTime.now().toUtc().toIso8601String(),
    });
  }

  static NepaliKundaliModel _getMockNepali(int chartId) {
    int offset = (chartId.toString().hashCode.abs()) % 12;
    List<String> signsEn = [
      "Aries",
      "Taurus",
      "Gemini",
      "Cancer",
      "Leo",
      "Virgo",
      "Libra",
      "Scorpio",
      "Sagittarius",
      "Capricorn",
      "Aquarius",
      "Pisces",
    ];
    List<String> signsDev = [
      "१",
      "२",
      "३",
      "४",
      "५",
      "६",
      "७",
      "८",
      "९",
      "१०",
      "११",
      "१२",
    ];

    return NepaliKundaliModel.fromJson({
      "ascendant": {
        "sign_en": signsEn[offset],
        "sign_devanagari": signsDev[offset],
        "degree_devanagari": "१२.५",
      },
      "houses": List.generate(12, (index) {
        int houseNum = index + 1;
        int signIdx = (offset + index) % 12;

        List<Map<String, dynamic>> planets = [];
        if (houseNum == 2) {
          planets.add({
            "key": "sun",
            "name_devanagari": "सूर्य",
            "degree_devanagari": "१४.३२",
            "retrograde": false,
          });
        }
        if (houseNum == 3) {
          planets.add({
            "key": "moon",
            "name_devanagari": "चन्द्र",
            "degree_devanagari": "५.२",
            "retrograde": false,
          });
        }
        if (houseNum == 4) {
          planets.add({
            "key": "mars",
            "name_devanagari": "मंगल",
            "degree_devanagari": "२१.१",
            "retrograde": false,
          });
        }
        if (houseNum == 5) {
          planets.add({
            "key": "mercury",
            "name_devanagari": "बुध",
            "degree_devanagari": "२८.५६",
            "retrograde": false,
          });
        }
        if (houseNum == 6) {
          planets.add({
            "key": "jupiter",
            "name_devanagari": "गुरु",
            "degree_devanagari": "५.१२",
            "retrograde": false,
          });
        }
        if (houseNum == 7) {
          planets.add({
            "key": "venus",
            "name_devanagari": "शुक्र",
            "degree_devanagari": "१८.३३",
            "retrograde": false,
          });
        }
        if (houseNum == 8) {
          planets.add({
            "key": "saturn",
            "name_devanagari": "शनि",
            "degree_devanagari": "२६.०९",
            "retrograde": false,
          });
        }

        return {
          "house": houseNum,
          "sign_en": signsEn[signIdx],
          "sign_devanagari": signsDev[signIdx],
          "planets": planets,
        };
      }),
    });
  }
}
