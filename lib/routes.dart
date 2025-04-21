import 'package:flutter/material.dart';
import 'package:zodeb/constants/bottom_bar.dart';
import 'package:zodeb/features/auth/screens/main_auth.dart';
import 'package:zodeb/features/rooms/screen/room_details_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case MainAuth.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const MainAuth(),
      );
    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomBar(),
      );
    case RoomDetailsScreen.routeName:
      final room = routeSettings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => RoomDetailsScreen(room: room),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) {
          return const Scaffold(
            body: Center(child: Column(children: [Text("Error occured.")])),
          );
        },
      );
  }
}
