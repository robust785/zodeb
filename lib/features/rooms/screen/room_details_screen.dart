// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../constants/global_variables.dart';

class RoomDetailsScreen extends StatelessWidget {
  static const String routeName = '/room-details';
  final Map<String, dynamic> room;
  final String currentUser; // Add this to track current user

  const RoomDetailsScreen({
    super.key,
    required this.room,
    required this.currentUser,
  });

  Future<void> _removeMember(BuildContext context, String memberName) async {
    try {
      final response = await http.delete(
        Uri.parse('$uri/api/room/remove-member'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'roomName': room['name'],
          'memberName': memberName,
          'creatorName': currentUser,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Member removed successfully')),
        );
        Navigator.pop(context); // Go back to rooms list
      } else {
        final errorMsg = jsonDecode(response.body)['msg'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg ?? 'Failed to remove member')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sortedMembers = List<Map<String, dynamic>>.from(room['members'])
      ..sort((a, b) => b['totalQuestions'].compareTo(a['totalQuestions']));

    final isCreator = currentUser == room['createdBy'];
    final totalProblems = sortedMembers.fold<int>(
        0, (sum, member) => sum + (member['totalQuestions'] as int));
    final averageProblems = totalProblems / sortedMembers.length;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                room['name'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blue[700]!,
                      Colors.blue[500]!,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -50,
                      top: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),

          // Stats Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(
                        context,
                        'Members',
                        sortedMembers.length.toString(),
                        Icons.people,
                        Colors.purple,
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: Colors.grey[300],
                      ),
                      _buildStatCard(
                        context,
                        'Problems',
                        totalProblems.toString(),
                        Icons.extension,
                        Colors.orange,
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: Colors.grey[300],
                      ),
                      _buildStatCard(
                        context,
                        'Average',
                        averageProblems.toStringAsFixed(1),
                        Icons.analytics,
                        Colors.green,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Leaderboard Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Leaderboard',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.emoji_events,
                            size: 16, color: Colors.blue[700]),
                        const SizedBox(width: 4),
                        Text(
                          'Top Performers',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Members List
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final member = sortedMembers[index];
                final isTopThree = index < 3;
                final rankColors = [
                  Colors.amber[400],
                  Colors.grey[400],
                  Colors.brown[300]
                ];
                final rankIcons = ['🏆', '🥈', '🥉'];
                final isMemberCreator = member['name'] == room['createdBy'];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Card(
                    elevation: isTopThree ? 4 : 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: isTopThree
                            ? LinearGradient(
                                colors: [
                                  rankColors[index]!.withOpacity(0.2),
                                  Colors.white,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              )
                            : null,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: Stack(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isTopThree
                                    ? rankColors[index]!.withOpacity(0.2)
                                    : Colors.blue[50],
                              ),
                              child: Center(
                                child: isTopThree
                                    ? Text(
                                        rankIcons[index],
                                        style: const TextStyle(fontSize: 20),
                                      )
                                    : Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          color: Colors.blue[700],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                              ),
                            ),
                            if (isMemberCreator)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.amber[400],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        title: Text(
                          member['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            Icon(
                              Icons.workspace_premium,
                              size: 14,
                              color: isTopThree
                                  ? rankColors[index]
                                  : Colors.grey[400],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isTopThree
                                  ? 'Top ${index + 1}'
                                  : 'Rank ${index + 1}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isTopThree
                                    ? rankColors[index]!.withOpacity(0.2)
                                    : Colors.blue[50],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 16,
                                    color: isTopThree
                                        ? rankColors[index]
                                        : Colors.blue[700],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${member['totalQuestions']}',
                                    style: TextStyle(
                                      color: isTopThree
                                          ? rankColors[index]
                                          : Colors.blue[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isCreator && !isMemberCreator) ...[
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                color: Colors.red,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Remove Member'),
                                      content: Text(
                                          'Are you sure you want to remove ${member['name']} from the room?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _removeMember(
                                                context, member['name']);
                                          },
                                          child: const Text(
                                            'Remove',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: sortedMembers.length,
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
