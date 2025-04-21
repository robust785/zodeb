// ignore_for_file: unused_local_variable, deprecated_member_use, use_build_context_synchronously

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zodeb/constants/toast_msg.dart';
import 'package:zodeb/features/auth/screens/main_auth.dart';
import 'package:zodeb/features/auth/services/auth_services.dart';
import 'package:zodeb/features/home/services/platform_service.dart';
import 'package:zodeb/provider/user_provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthServices authService = AuthServices();
  final PlatformService platformService = PlatformService();
  int leetcodeSolved = 0;
  int gfgSolved = 0;
  int totalSolved = 0;
  bool isLoading = true;

  final List<String> codingTips = [
    "The first computer programmer was Ada Lovelace in the 1800s.",
    "The first high-level programming language was Fortran, created in the 1950s.",
    "The 'Hello, World!' program is a tradition for starting any new programming language.",
    "Over 700 programming languages exist today.",
    "The first virus for MS-DOS was called Brain and was created in 1986.",
    "The term 'bug' in computing originated from a real insect causing a hardware malfunction.",
    "Python was named after the comedy series Monty Python’s Flying Circus.",
    "Java was initially called Oak.",
    "HTML is not a programming language; it's a markup language.",
    "The world’s first website is still online at info.cern.ch.",
    "The original Windows OS was written in C.",
    "GitHub has over 100 million repositories.",
    "Linux is used to power over 90% of the world’s top supercomputers.",
    "Stack Overflow has more than 25 million questions asked by developers.",
    "The average developer writes around 50 lines of code a day that go into production.",
    "Bill Gates wrote his first software program at 13 years old.",
    "Code written in 1958 for the Voyager spacecraft is still running today.",
    "NASA uses 400,000 lines of code in its space shuttle program.",
    "Google’s search algorithm is one of the most closely guarded secrets in coding.",
    "Facebook was originally coded in PHP.",
    "The '404' error was named after a room at CERN where the web’s first servers were stored.",
    "Developers often spend more time reading code than writing it.",
    "Open-source software powers much of the internet today.",
    "Apple’s macOS is built on a UNIX-based system called Darwin.",
    "C is considered the mother of many modern languages like C++, Java, and Python.",
    "Some companies still use COBOL, a language developed in the 1950s.",
    "Slack, a modern communication tool, was originally a game project.",
    "Google’s entire codebase is stored in a single massive repository.",
    "Programmers have been solving algorithms since the ancient Greek era.",
    "The average salary of a software engineer is among the highest in tech.",
    "Programmers use rubber ducks to debug their code by explaining it out loud.",
    "Coding can be done on smartphones using mobile IDEs.",
    "Some programming languages are written in emojis.",
    "JavaScript was created in just 10 days.",
    "Hackers can use just a few lines of code to breach insecure systems.",
    "Video games have some of the most complex codebases in software.",
    "AI-generated code is becoming more accurate every year.",
    "NASA once lost a dollar 125M Mars orbiter due to a unit conversion bug in code.",
    "The longest running software project is GNU, started in 1983.",
    "Assembly language is the closest you can get to speaking with your hardware.",
    "Programmers often use dark mode to reduce eye strain and save battery.",
    "Programmers can work remotely from any part of the world.",
    "Some developers can type more than 120 words per minute.",
    "Quantum computing may change how we code forever.",
    "Coding is now part of the school curriculum in many countries.",
    "Many startups begin with a single coder and a laptop.",
    "Game engines like Unity and Unreal use C# and C++ respectively.",
    "You can build your own OS if you learn C and Assembly.",
    "APIs allow software programs to talk to each other like humans do.",
    "Learning to code can teach you logical thinking and patience."
  ];

  late String currentTip;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _getUserData();
    _fetchStats();
    currentTip = codingTips[random.nextInt(codingTips.length)];
    debugPrint("inside home page");
  }

  Future<void> _getUserData() async {
    await authService.getUserData(context);
    setState(() {});
  }

  Future<void> _fetchStats() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final leetcodeStats = await platformService
        .fetchLeetcodeStats(userProvider.user.leetcodelink);
    final gfgStats =
        await platformService.fetchGFGStats(userProvider.user.gfglink);

    if (mounted) {
      setState(() {
        leetcodeSolved = leetcodeStats['totalSolved'] ?? 0;
        gfgSolved = gfgStats;
        totalSolved = leetcodeSolved + gfgSolved;
        isLoading = false;
      });
    }
  }

  Future<void> _refreshStats() async {
    setState(() => isLoading = true);
    await _fetchStats();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.white),
              accountName: Text(
                user.name.toUpperCase(),
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              accountEmail: Text(
                user.email,
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Color.fromARGB(255, 228, 228, 228),
                child: ClipOval(child: Icon(Icons.person_outline, size: 50)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile Update"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("About Us"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () async {
                try {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          "Alert",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: const Text(
                          "You really want to logout ?",
                          style: TextStyle(fontSize: 20),
                        ),
                        actions: [
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          TextButton(
                            child: const Text("Yes"),
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setString('x-auth-token', '');
                              Navigator.popAndPushNamed(
                                context,
                                MainAuth.routeName,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                } catch (e) {
                  toastMsg(msg: e.toString());
                }
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.08,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onDoubleTap: _getUserData,
              child: const Text(
                "Zodeb",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              'Hi, ${user.name.toUpperCase()}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        elevation: 2,
        backgroundColor: Colors.white,
        shadowColor: Colors.grey,
        surfaceTintColor: Colors.transparent,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshStats,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Total Problems Solved",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (isLoading)
                            const CircularProgressIndicator()
                          else
                            Text(
                              totalSolved.toString(),
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.2,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildPlatformStats(
                            "LeetCode",
                            leetcodeSolved,
                            Colors.orange,
                            Icons.code,
                          ),
                          const Divider(),
                          _buildPlatformStats(
                            "GeeksForGeeks",
                            gfgSolved,
                            Colors.green,
                            Icons.computer,
                          ),
                          const Divider(),
                          _buildPlatformStats(
                            "CodeForces",
                            0,
                            Colors.red,
                            Icons.speed,
                          ),
                          const Divider(),
                          _buildPlatformStats(
                            "CodeChef",
                            0,
                            Colors.brown,
                            Icons.restaurant_menu,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.lightbulb, color: Colors.amber),
                              SizedBox(width: 10),
                              Text(
                                "Coding Tip of the Day",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            currentTip,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlatformStats(
    String platform,
    int problems,
    Color color,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  platform,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: problems / 500, // Max value set to 500 for progress
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Text(
            problems.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
