// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:zodeb/features/rooms/screen/room_details_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../constants/global_variables.dart';

class RoomScreen extends StatefulWidget {
  final String currentUser;
  const RoomScreen({super.key, required this.currentUser});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  final TextEditingController _roomNameController = TextEditingController();
  final TextEditingController _roomCodeController = TextEditingController();
  List<Map<String, dynamic>> rooms = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRooms();
  }

  Future<void> fetchRooms() async {
    try {
      if (!mounted) return;
      setState(() => isLoading = true);
      final response = await http.get(
        Uri.parse('$uri/api/rooms/${widget.currentUser}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (!mounted) return;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          rooms = List<Map<String, dynamic>>.from(data['rooms']);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch rooms')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch rooms')),
      );
    }
  }

  void _showCreateRoomDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Create Room',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: _roomNameController,
          decoration: InputDecoration(
            hintText: 'Enter room name',
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _roomNameController.clear();
              Navigator.pop(context);
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              final roomName = _roomNameController.text.trim();
              if (roomName.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a room name')),
                );
                return;
              }

              // Validate room name: only allow letters, numbers, and spaces
              if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(roomName)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Room name can only contain letters, numbers, and spaces'),
                  ),
                );
                return;
              }

              try {
                final response = await http.post(
                  Uri.parse('$uri/api/room/create'),
                  headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                  },
                  body: jsonEncode({
                    'name': roomName,
                    'createdBy': widget.currentUser,
                  }),
                );

                if (response.statusCode == 200) {
                  fetchRooms();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Room created successfully')),
                  );
                } else {
                  final responseBody = jsonDecode(response.body);
                  final error = responseBody['msg'] ??
                      responseBody['error'] ??
                      'Failed to create room';
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error)),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Failed to create room. Please try again.')),
                );
              }
              _roomNameController.clear();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showJoinRoomDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Join Room',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: _roomCodeController,
          decoration: InputDecoration(
            hintText: 'Enter room code',
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _roomCodeController.clear();
              Navigator.pop(context);
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_roomCodeController.text.trim().isEmpty) return;

              try {
                final response = await http.post(
                  Uri.parse('$uri/api/room/join'),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({
                    'name': _roomCodeController.text.trim(),
                    'memberName': widget.currentUser,
                  }),
                );

                if (response.statusCode == 200) {
                  fetchRooms();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Joined room successfully')),
                  );
                } else {
                  final error = jsonDecode(response.body)['msg'];
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error ?? 'Failed to join room')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to join room')),
                );
              }
              _roomCodeController.clear();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Coding Rooms',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              heroTag: 'join_room',
              onPressed: _showJoinRoomDialog,
              label: const Text(
                'Join Room',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              icon: const Icon(Icons.group_add, size: 24),
              backgroundColor: const Color(0xFF48BB78),
              elevation: 4,
            ),
            const SizedBox(height: 16),
            FloatingActionButton.extended(
              heroTag: 'create_room',
              onPressed: _showCreateRoomDialog,
              label: const Text(
                'Create Room',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              icon: const Icon(Icons.add, size: 24),
              backgroundColor: const Color(0xFF4299E1),
              elevation: 4,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: RefreshIndicator(
        onRefresh: fetchRooms,
        color: const Color(0xFF4299E1),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF4299E1),
                ),
              )
            : rooms.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.group_outlined,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'No Rooms Available',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Create or join a room to get started',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    itemCount: rooms.length,
                    itemBuilder: (context, index) {
                      final room = rooms[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              spreadRadius: 0,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RoomDetailsScreen.routeName,
                                arguments: {
                                  ...room,
                                  'currentUser': widget.currentUser,
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF4299E1).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.code_rounded,
                                        color: Color(0xFF4299E1),
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          room['name'],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF2D3748),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Created by ${room['createdBy']}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right_rounded,
                                    color: Color(0xFF4299E1),
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  @override
  void dispose() {
    _roomNameController.dispose();
    _roomCodeController.dispose();
    super.dispose();
  }
}
