// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:zodeb/features/chatbot/screen/chatbot_screen.dart';
import 'package:zodeb/features/home/screen/home_screen.dart';
import 'package:zodeb/features/link%20update/screen/link_update.dart';
import 'package:zodeb/features/rooms/screen/room_screen.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = '/bottom-nav-bar';
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  List<Widget> pages = [
    const HomeScreen(),
    const RoomScreen(),
    const ChatbotScreen(),
    const LinkUpdate(),
  ];
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;
  void setPage(int p) {
    setState(() {
      _page = p;
      debugPrint("Current Page Index: $_page");
    });
  }

  @override
  void initState() {
    super.initState();
    debugPrint("inside bt nav bar");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              elevation:
                  0, // Remove default elevation as we're using custom shadow
              onTap: setPage,
              currentIndex: _page,
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              iconSize: 24,
              items: const [
                BottomNavigationBarItem(
                  label: "Home",
                  icon: Icon(Icons.home_rounded),
                  activeIcon: Icon(Icons.home_rounded, size: 28),
                ),
                BottomNavigationBarItem(
                  label: "Rooms",
                  icon: Icon(Icons.fire_extinguisher_outlined),
                  activeIcon: Icon(Icons.fire_extinguisher, size: 28),
                ),
                BottomNavigationBarItem(
                  label: "Chat",
                  icon: Icon(Icons.chat_bubble_outline_rounded),
                  activeIcon: Icon(Icons.chat_bubble_rounded, size: 28),
                ),
                BottomNavigationBarItem(
                  label: "Profile",
                  icon: Icon(Icons.person_outline_rounded),
                  activeIcon: Icon(Icons.person_rounded, size: 28),
                ),
              ],
            ),
          ),
        ),
      ),
      body: pages[_page],
    );
  }
}
