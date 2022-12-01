import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login_and_signup_using_sqflite/Model/user_model.dart';
import 'package:login_and_signup_using_sqflite/commons/common_helper.dart';
import 'package:login_and_signup_using_sqflite/commons/common_text_form_field.dart';
import 'package:login_and_signup_using_sqflite/commons/login_and_signup_header.dart';
import 'package:login_and_signup_using_sqflite/data_base_handler/db_helper.dart';
import 'package:login_and_signup_using_sqflite/Screens/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  TextEditingController conEmail = TextEditingController();
  TextEditingController conPassword = TextEditingController();
  DataBaseHelper? dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DataBaseHelper.instance;
  }

  login() async {
    String email = conEmail.text;
    String passwd = conPassword.text;

    if (passwd.isEmpty) {
      alertDialog(context, "Please Enter Password");
    } else {
      await dbHelper!.getLoginUser(email, passwd).then(( userData) {
        if (userData != null) {
          setSP(userData).whenComplete(() {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (Route<dynamic> route) => false,
            );
          });
        } else {
          alertDialog(context, "Error: User Not Found");
        }
      }).catchError((error) {
        debugPrint(error.toString());
        alertDialog(context, "Error: Login Fail");
      });
    }
  }

  Future setSP( user) async {
    final SharedPreferences sp = await _pref;
    sp.setString("user_data", json.encode(user));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LoginAndSignupHeader(headerName: 'Login'),
              CommonTextFormField(
                controller: conEmail,
                icon: Icons.email,
                inputType: TextInputType.emailAddress,
                hintName: 'Email',
              ),
              const SizedBox(height: 10.0),
              CommonTextFormField(
                controller: conPassword,
                icon: Icons.lock,
                hintName: 'Password',
                isObscureText: true,
              ),
              Container(
                margin: const EdgeInsets.all(30.0),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: login,
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Does not have account? '),
                  ElevatedButton(
                    child: const Text('Signup'),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpScreen()));
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
