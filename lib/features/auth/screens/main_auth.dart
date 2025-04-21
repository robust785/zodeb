import 'package:flutter/material.dart';
import 'package:zodeb/constants/toast_msg.dart';
import 'package:zodeb/features/auth/screens/create_account.dart';
import 'package:zodeb/features/auth/services/auth_services.dart';

class MainAuth extends StatefulWidget {
  const MainAuth({super.key});
  static const String routeName = "/auth-screen";

  @override
  State<MainAuth> createState() => _MainAuthState();
}

class _MainAuthState extends State<MainAuth> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool isLoading = false;
  AuthServices authServices = AuthServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.23),
                const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 50,
                    fontFamily: 'CaviarDreams',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  height: 50, //height of input field
                  child: TextField(
                    controller: emailController,
                    enabled: true,
                    style: const TextStyle(
                      fontSize: 20.0, //size badhega isse jo text type hoga uska
                    ),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      filled: true,
                      hintText: "Email",
                      hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  height: 50, //height of input field
                  child: TextField(
                    controller: passController,
                    enabled: true,
                    style: const TextStyle(
                      fontSize: 20.0, //size badhega isse jo text type hoga uska
                    ),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      filled: true,
                      hintText: "Password",
                      hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  height: 50,
                  width: MediaQuery.of(context).size.width, //height of button
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.black),
                    ),
                    onPressed: () {
                      if (emailController.text == "") {
                        toastMsg(
                          msg: "Please enter email",
                          color_bg: Colors.yellow,
                          color_text: Colors.black,
                        );
                        return;
                      }

                      if (passController.text == "") {
                        toastMsg(
                          msg: "Please enter password",
                          color_bg: Colors.yellow,
                          color_text: Colors.black,
                        );
                        return;
                      }
                      authServices.logInUser(
                        context: context,
                        email: emailController.text,
                        password: passController.text,
                      );
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        "New to Zodeb ? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreateAccountScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Create Account",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
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
