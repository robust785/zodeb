// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:zodeb/constants/toast_msg.dart';
import 'package:zodeb/features/auth/screens/main_auth.dart';
import 'package:zodeb/features/auth/services/auth_services.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccountScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool isLoading = false;
  AuthServices authServices = AuthServices();
  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  height: 50, //height of input field
                  child: TextField(
                    controller: nameController,
                    enabled: true,
                    style: const TextStyle(
                      fontSize: 20.0, //size badhega isse jo text type hoga uska
                    ),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_2_outlined),
                      filled: true,
                      hintText: "Name",
                      hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(131, 158, 158, 158),
                        ),
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
                        borderSide: BorderSide(
                          color: Color.fromARGB(131, 158, 158, 158),
                        ),
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
                      prefixIcon: Icon(Icons.password_outlined),
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
                    onPressed: () async {
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

                      bool allGood = await authServices.signUpUser(
                        context: context,
                        name: nameController.text,
                        email: emailController.text,
                        password: passController.text,
                      );
                      if (allGood) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainAuth(),
                          ),
                        );
                      }

                      // setState(() {
                      //   isLoading = true;
                      //   authServices.signUpUser(
                      //       name: nameController.text,
                      //       email: emailController.text,
                      //       password: passController.text);
                      // });
                      // Future.delayed(const Duration(seconds: 2), () {
                      //   setState(() {
                      //     isLoading = false;

                      //     Navigator.pushReplacement(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => const MainAuth(),
                      //       ),
                      //     );
                      //   });
                      // });
                    },
                    child:
                    //  isLoading == true
                    //     ? const Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Text(
                    //             "Loading...    ",
                    //             style: TextStyle(
                    //                 fontSize: 20, color: Colors.white),
                    //           ),
                    //           CircularProgressIndicator(
                    //             color: Colors.white,
                    //           ),
                    //         ],
                    //       )
                    //     :
                    const Text(
                      "SignUp",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
