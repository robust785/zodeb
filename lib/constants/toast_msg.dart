// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void toastMsg({
  required String msg,
  Color color_bg = Colors.red,
  Color color_text = Colors.white,
}) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: color_bg,
    textColor: color_text,
    fontSize: 16.0,
  );
}
