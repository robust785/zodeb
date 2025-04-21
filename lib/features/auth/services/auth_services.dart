// ignore_for_file: use_build_context_synchronously

// import 'dart:convert';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zodeb/constants/bottom_bar.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import 'package:zodeb/constants/global_variables.dart';
import 'package:zodeb/constants/http_error_handle.dart';
import 'package:zodeb/constants/toast_msg.dart';
import 'package:http/http.dart' as http;
import 'package:zodeb/features/auth/model/user_model.dart';
import 'package:zodeb/provider/user_provider.dart';

class AuthServices {
  Future<bool> signUpUser({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    bool success = false;
    try {
      UserModel user = UserModel(
        name: name,
        password: password,
        photo: "",
        leetcodelink: "",
        gfglink: "",
        codecheflink: "",
        codeforceslink: "",
        id: "",

        email: email,
        type: 'user',
        token: '',
      );

      //sending data to DB
      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (res.statusCode == 200) {
        success = true;
      }

      httpErrorHandle(
        context: context,
        response: res,
        onSuccess: () {
          toastMsg(
            msg: "Account created. Login with same Credentials",
            color_bg: Colors.green,
          );
          success = true;
        },
      );

      return success;
    } catch (e) {
      toastMsg(msg: e.toString(), color_bg: Colors.red);
    }
    return success;
  }

  void logInUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse("$uri/api/login"),
        body: jsonEncode({'email': email, 'password': password}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // debugPrint(jsonDecode(res.body));
      httpErrorHandle(
        context: context,
        response: res,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          Navigator.pushNamedAndRemoveUntil(
            context,
            BottomBar.routeName,
            (route) => false,
          );

          toastMsg(msg: "Login successful.", color_bg: Colors.green);
        },
      );
    } catch (e) {
      toastMsg(msg: e.toString(), color_bg: Colors.red);
    }
  }

  //get user data
  Future<void> getUserData(BuildContext context) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString("x-auth-token");
      //debugPrint("this the the token: $token");
      if (token == null) {
        pref.setString("x-auth-token", "");
      }
      //debugPrint("token not null");

      var tokenRes = await http.post(
        Uri.parse("$uri/tokenIsValid"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token!,
        },
      );
      //debugPrint("tokenRes: $tokenRes");

      var response = jsonDecode(tokenRes.body);

      //if response =true get the user data
      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse("$uri/"),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
            "x-auth-token": token,
          },
        );

        //debugPrint("$response");
        Provider.of<UserProvider>(context, listen: false).setUser(userRes.body);
      }
    } catch (e) {
      if (context.mounted) {
        //debugPrint(e.toString());
        toastMsg(msg: e.toString());
      }
    }
  } //end of getUserData()
}
