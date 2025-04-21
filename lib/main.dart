import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zodeb/constants/bottom_bar.dart';
import 'package:zodeb/constants/loading_screen.dart';
import 'package:zodeb/features/auth/screens/main_auth.dart';
import 'package:zodeb/provider/user_provider.dart';
import 'package:zodeb/features/auth/services/auth_services.dart';
import 'package:zodeb/routes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthServices authService = AuthServices();
  // ignore: unused_field
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    await authService.getUserData(context);
    setState(() {
      _isLoading = false; // Set loading to false once data is fetched
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        return generateRoute(settings);
      },
      debugShowCheckedModeBanner: false,
      title: "Zodeb",
      theme: ThemeData(
        colorSchemeSeed: Colors.white,
        useMaterial3: true,
        fontFamily: 'CaviarDreams',
      ),
      home: FutureBuilder(
        future: authService.getUserData(context), // Get user data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen(); // Loading indicator
          } else {
            return Provider.of<UserProvider>(context).user.token.isNotEmpty
                ? const BottomBar()
                : const MainAuth();
          }
        },
      ),
    );
  }
}
