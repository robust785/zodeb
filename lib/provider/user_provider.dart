import 'package:flutter/material.dart';
import 'package:zodeb/features/auth/model/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = UserModel(
    id: "",
    name: "",
    email: "",
    password: "",
    photo: "",
    leetcodelink: "",
    gfglink: "",
    codecheflink: "",
    codeforceslink: "",
    type: "",
    totalQuestions: 0,
    token: "",
  );

  UserModel get user => _user;

  void setUser(String user) {
    _user = UserModel.fromJson(user);
    notifyListeners();
  }
}
