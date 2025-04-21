import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zodeb/constants/toast_msg.dart';

void httpErrorHandle({
  required BuildContext context,
  required http.Response response,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;

    case 400:
      toastMsg(msg: jsonDecode(response.body)['msg']);
      break;

    case 500:
      toastMsg(msg: jsonDecode(response.body)['error']);
      break;

    default:
      toastMsg(msg: response.body);
  }
}
