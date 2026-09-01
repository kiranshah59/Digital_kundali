import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class ProfileService {
  static const String baseUrl = 'https://api.digitalkundali.com/api';

  static List<dynamic> _mockedProfiles = [];
  static List<dynamic> _lastApiProfiles = [];

  static Future<void> _loadMockedProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final String prefix = AuthService.userId ?? 'guest';
    final String? profilesJson = prefs.getString('${prefix}_mocked_profiles');
    if (profilesJson != null) {
      _mockedProfiles = jsonDecode(profilesJson);
    }
    final String? apiJson = prefs.getString('${prefix}_cached_api_profiles');
    if (apiJson != null) {
      _lastApiProfiles = jsonDecode(apiJson);
    }
  }

  static Future<void> _saveMockedProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final String prefix = AuthService.userId ?? 'guest';
    await prefs.setString('${prefix}_mocked_profiles', jsonEncode(_mockedProfiles));
    await prefs.setString('${prefix}_cached_api_profiles', jsonEncode(_lastApiProfiles));
  }

  static Future<void> clearProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final String prefix = AuthService.userId ?? 'guest';
    await prefs.remove('${prefix}_mocked_profiles');
    await prefs.remove('${prefix}_cached_api_profiles');
    _mockedProfiles = [];
    _lastApiProfiles = [];
  }

  static List<dynamic> _getMergedProfiles(List<dynamic> apiProfiles) {
    final Map<int, dynamic> merged = {};
    for (var p in apiProfiles) {
      merged[p['id']] = p;
    }
    for (var p in _mockedProfiles) {
      merged[p['id']] = p;
    }
    return merged.values.toList();
  }

  static Future<Map<String, dynamic>> getProfiles() async {
    await _loadMockedProfiles();
    final url = Uri.parse('$baseUrl/birth-profiles');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (AuthService.token != null)
            'Authorization': 'Bearer ${AuthService.token}',
        },
      ).timeout(const Duration(seconds: 30));

      final decodedData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> apiProfiles = decodedData['data'] ?? [];
        _lastApiProfiles = apiProfiles;
        await _saveMockedProfiles();
        
        return {
          'success': true,
          'data': _getMergedProfiles(apiProfiles),
        };
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

    // Create the profile map to be used either by API or locally
    final newProfile = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'full_name': fullName,
      'relationship': 'self',
      'gender': 'female',
      'date_of_birth': dateOfBirth,
      'time_of_birth': timeOfBirth,
      'place_of_birth': birthPlaceName,
      'birth_place_name': birthPlaceName,
      'is_primary': false,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (AuthService.token != null)
            'Authorization': 'Bearer ${AuthService.token}',
        },
        body: jsonEncode({
          ...newProfile,
          'time_of_birth_precision': 'exact',
          'latitude': 27.6710464, // Mock for now
          'longitude': 85.4297794, // Mock for now
          'timezone': 'Asia/Kathmandu',
          'calendar_system': 'AD',
        }),
      ).timeout(const Duration(seconds: 30));

      final decodedData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // API succeeded, but we also save locally in case backend doesn't persist properly
        _mockedProfiles.add(newProfile);
        await _saveMockedProfiles();
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
      final response = await http.put(
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
      ).timeout(const Duration(seconds: 1));

      final decodedData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        await _updateMockedProfileLocally(id, updatedData, originalProfile);
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
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (AuthService.token != null)
            'Authorization': 'Bearer ${AuthService.token}',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        await _deleteMockedProfileLocally(id);
        return {
          'success': true,
          'message': 'Profile deleted successfully',
        };
      } else if (response.statusCode == 404) {
        // If the backend says it doesn't exist, we must still clean it up locally
        await _deleteMockedProfileLocally(id);
        return {
          'success': true,
          'message': 'Profile removed',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to delete profile',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error while deleting profile',
      };
    }
  }

  static Future<void> _deleteMockedProfileLocally(int id) async {
    _mockedProfiles.removeWhere((p) => p['id'] == id);
    _lastApiProfiles.removeWhere((p) => p['id'] == id);
    await _saveMockedProfiles();
  }

  static Future<void> _updateMockedProfileLocally(int id, Map<String, dynamic> updatedData, Map<String, dynamic>? originalProfile) async {
    final index = _mockedProfiles.indexWhere((p) => p['id'] == id);
    if (index != -1) {
      final current = Map<String, dynamic>.from(_mockedProfiles[index]);
      current.addAll(updatedData);
      _mockedProfiles[index] = current;
    } else if (originalProfile != null) {
      // It's an API profile being overridden locally
      final current = Map<String, dynamic>.from(originalProfile);
      current.addAll(updatedData);
      _mockedProfiles.add(current);
    }
    await _saveMockedProfiles();
  }
}
