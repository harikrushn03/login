import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

alertDialog(BuildContext context, String msg) {
  debugPrint("msg: ------------->>> $msg");
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.black26,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

validateEmail(String email) {
  final emailReg = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  return emailReg.hasMatch(email);
}
