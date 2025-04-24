import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/global_variables.dart';
import 'package:flutter/material.dart';

class PlatformService {
  Future<bool> updateTotalQuestions(String userId, int totalCount) async {
    try {
      if (userId.isEmpty) {
        debugPrint('Error: userId is empty');
        return false;
      }

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('x-auth-token') ?? '';

      final response = await http.post(
        Uri.parse('$uri/api/user/update-questions'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode({
          'userId': userId.trim(), // Ensure no whitespace
          'totalQuestions': totalCount,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('Total questions updated successfully: $data');
        return true;
      } else {
        debugPrint(
            'Failed to update total questions. Status code: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Error updating total questions: $e');
      return false;
    }
  }

  Future<void> updateCombinedTotal(String userId) async {
    try {
      final leetcodeStats = await fetchLeetcodeStats(null, userId);
      final gfgTotal = await fetchGFGStats(null, userId);
      final combinedTotal = (leetcodeStats['totalSolved'] ?? 0) + gfgTotal;

      await updateTotalQuestions(userId, combinedTotal);
    } catch (e) {
      debugPrint('Error updating combined total: $e');
    }
  }

  Future<Map<String, dynamic>> fetchLeetcodeStats(
      String? username, String userId) async {
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
        final data = json.decode(response.body);
        return data;
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

  Future<int> fetchGFGStats(String? username, String userId) async {
    if (username == null || username.isEmpty) {
      return 0;
    }

    try {
      final response = await http.get(Uri.parse('$uri/api/gfg/$username'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final totalSolved = data['totalSolved'] ?? 0;
        return totalSolved;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }
}
