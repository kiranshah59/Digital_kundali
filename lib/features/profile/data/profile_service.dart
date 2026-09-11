import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../auth/data/auth_service.dart';

class ProfileService {
  static const String baseUrl = 'https://api.digitalkundali.com/api';

  static Future<void> clearProfiles() async {
    
  }

  static Future<Map<String, dynamic>> getProfiles() async {
    final url = Uri.parse('$baseUrl/birth-profiles');

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
        final List<dynamic> apiProfiles = decodedData['data'] ?? [];
        return {'success': true, 'data': apiProfiles};
      } else {
        return {
          'success': false,
          'message': decodedData['message'] ?? 'Failed to load profiles',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error while loading profiles',
      };
    }
  }

  static Future<Map<String, dynamic>> addProfile({
    required String fullName,
    required String dateOfBirth,
    required String timeOfBirth,
    required String birthPlaceName,
  }) async {
    final url = Uri.parse('$baseUrl/birth-profiles');

    final newProfilePayload = {
      'full_name': fullName,
      'relationship': 'self',
      'gender': 'female',
      'date_of_birth': dateOfBirth,
      'time_of_birth': timeOfBirth,
      'place_of_birth': birthPlaceName,
      'birth_place_name': birthPlaceName,
      'is_primary': false,
      'time_of_birth_precision': 'exact',
      'latitude': 27.6710464, // Mock for now, requires Geocoding integration later
      'longitude': 85.4297794, // Mock for now
      'timezone': 'Asia/Kathmandu',
      'calendar_system': 'AD',
    };

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
            body: jsonEncode(newProfilePayload),
          )
          .timeout(const Duration(seconds: 30));

      final decodedData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'data': decodedData['data'],
          'message': decodedData['message'] ?? 'Profile added successfully',
        };
      } else {
        return {
          'success': false,
          'message': decodedData['message'] ?? 'Failed to create profile',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error while creating profile',
      };
    }
  }

  static Future<Map<String, dynamic>> updateProfile({
    required int id,
    required String fullName,
    required String dateOfBirth,
    required String timeOfBirth,
    required String birthPlaceName,
    required Map<String, dynamic> originalProfile,
  }) async {
    final url = Uri.parse('$baseUrl/birth-profiles/$id');

    final updatedData = {
      'full_name': fullName,
      'date_of_birth': dateOfBirth,
      'time_of_birth': timeOfBirth,
      'birth_place_name': birthPlaceName,
      'place_of_birth': birthPlaceName,
    };

    try {

      final response = await http
          .put(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              if (AuthService.token != null)
                'Authorization': 'Bearer ${AuthService.token}',
            },
            body: jsonEncode({
              ...updatedData,
              'time_of_birth_precision': 'exact',
              'timezone': 'Asia/Kathmandu',
              'calendar_system': 'AD',
            }),
          )
          .timeout(const Duration(seconds: 30));

      final decodedData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'data': decodedData['data'],
          'message': decodedData['message'] ?? 'Profile updated successfully',
        };
      } else {
        return {
          'success': false,
          'message': decodedData['message'] ?? 'Failed to update profile',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error while updating profile',
      };
    }
  }

  static Future<Map<String, dynamic>> deleteProfile(int id) async {
    final url = Uri.parse('$baseUrl/birth-profiles/$id');

    try {
      final response = await http
          .delete(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              if (AuthService.token != null)
                'Authorization': 'Bearer ${AuthService.token}',
            },
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {'success': true, 'message': 'Profile deleted successfully'};
      } else if (response.statusCode == 404) {
        return {'success': true, 'message': 'Profile removed'};
      } else {
        return {'success': false, 'message': 'Failed to delete profile'};
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error while deleting profile',
      };
    }
  }
}
