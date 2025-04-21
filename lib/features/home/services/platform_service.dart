import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../constants/global_variables.dart';

class PlatformService {
  Future<Map<String, dynamic>> fetchLeetcodeStats(String? username) async {
    if (username == null || username.isEmpty) {
      return {
        'totalSolved': 0,
        'easySolved': 0,
        'mediumSolved': 0,
        'hardSolved': 0
      };
    }

    try {
      final response = await http.get(Uri.parse('$uri/api/leetcode/$username'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {
        'totalSolved': 0,
        'easySolved': 0,
        'mediumSolved': 0,
        'hardSolved': 0
      };
    } catch (e) {
      return {
        'totalSolved': 0,
        'easySolved': 0,
        'mediumSolved': 0,
        'hardSolved': 0
      };
    }
  }

  Future<int> fetchGFGStats(String? username) async {
    if (username == null || username.isEmpty) {
      return 0;
    }

    try {
      final response = await http.get(Uri.parse('$uri/api/gfg/$username'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['totalSolved'] ?? 0;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }
}
