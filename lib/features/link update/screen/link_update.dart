// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zodeb/constants/global_variables.dart';
import 'dart:convert';
import '../../../constants/http_error_handle.dart';
import '../../../constants/toast_msg.dart' as toast;
import '../../../provider/user_provider.dart';
import 'package:http/http.dart' as http;

class LinkUpdate extends StatefulWidget {
  const LinkUpdate({super.key});

  @override
  State<LinkUpdate> createState() => _LinkUpdateState();
}

class _LinkUpdateState extends State<LinkUpdate> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _leetcodeController = TextEditingController();
  final TextEditingController _gfgController = TextEditingController();
  final TextEditingController _codeforcesController = TextEditingController();
  final TextEditingController _codechefController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current user's data
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _leetcodeController.text = userProvider.user.leetcodelink ?? '';
    _gfgController.text = userProvider.user.gfglink ?? '';
    _codeforcesController.text = userProvider.user.codeforceslink ?? '';
    _codechefController.text = userProvider.user.codecheflink ?? '';
  }

  @override
  void dispose() {
    _leetcodeController.dispose();
    _gfgController.dispose();
    _codeforcesController.dispose();
    _codechefController.dispose();
    super.dispose();
  }

  Future<void> updateLinks() async {
    if (!mounted) return;

    try {
      setState(() => _isLoading = true);
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      final response = await http.post(
        Uri.parse('$uri/api/update-links'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'email': userProvider.user.email,
          'leetcodelink': _leetcodeController.text.trim(),
          'gfglink': _gfgController.text.trim(),
          'codeforceslink': _codeforcesController.text.trim(),
          'codecheflink': _codechefController.text.trim(),
        }),
      );

      if (!mounted) return;

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          if (response.statusCode == 200) {
            final updatedUserData = jsonEncode(jsonDecode(response.body));
            userProvider.setUser(updatedUserData);
            toast.toastMsg(
              msg: 'Links updated successfully!',
              color_bg: Colors.green,
            );
          }
        },
      );
    } catch (e) {
      if (mounted) {
        toast.toastMsg(msg: e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildPlatformField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color color,
    bool enabled = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: controller,
              enabled: enabled && !_isLoading,
              decoration: InputDecoration(
                hintText: hint,
                filled: true,
                fillColor: enabled ? Colors.grey.shade50 : Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: color),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isLoading,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text(
            'Update Profile Links',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.link_rounded,
                        size: 48,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Connect Your Coding Profiles',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Link your coding platform profiles to track your progress',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildPlatformField(
                          controller: _leetcodeController,
                          label: 'LeetCode Profile',
                          hint: 'Enter your LeetCode username',
                          icon: Icons.code,
                          color: Colors.orange,
                        ),
                        _buildPlatformField(
                          controller: _gfgController,
                          label: 'GeeksForGeeks Profile',
                          hint: 'Enter your GeeksForGeeks username',
                          icon: Icons.computer,
                          color: Colors.green,
                        ),
                        _buildPlatformField(
                          controller: _codeforcesController,
                          label: 'CodeForces Profile',
                          hint: 'Coming Soon',
                          icon: Icons.speed,
                          color: Colors.red,
                          enabled: false,
                        ),
                        _buildPlatformField(
                          controller: _codechefController,
                          label: 'CodeChef Profile',
                          hint: 'Coming Soon',
                          icon: Icons.restaurant_menu,
                          color: Colors.brown,
                          enabled: false,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : updateLinks,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Update Links',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
