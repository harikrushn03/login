import 'dart:math';

import 'package:flutter/material.dart';
import 'package:login_and_signup_using_sqflite/Model/user_model.dart';
import 'package:login_and_signup_using_sqflite/Screens/login_screen.dart';
import 'package:login_and_signup_using_sqflite/commons/common_helper.dart';
import 'package:login_and_signup_using_sqflite/commons/common_text_form_field.dart';
import 'package:login_and_signup_using_sqflite/commons/login_and_signup_header.dart';
import 'package:login_and_signup_using_sqflite/data_base_handler/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  final conUserName = TextEditingController();
  final conEmail = TextEditingController();
  final conPassword = TextEditingController();
  final conCPassword = TextEditingController();
  DataBaseHelper? dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DataBaseHelper.instance;
  }

  signUp() async {
    String uname = conUserName.text;
    String email = conEmail.text;
    String passwd = conPassword.text;
    String cPasswd = conCPassword.text;

    if (formKey.currentState!.validate()) {
      if (passwd != cPasswd) {
        alertDialog(context, 'Password Mismatch');
      } else {
        String code = await dbHelper!.getLastId();
        bool userCheck = await dbHelper!.checkUser(email);
        if (userCheck) {
          formKey.currentState!.save();
          UserModel userData = UserModel(
            userID: int.parse(code),
            userName: uname,
            email: email,
            password: passwd,
          );
          await dbHelper!.saveData(userData).then((userData) {
            alertDialog(context, "Successfully Saved");
            Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
          }).catchError((error) {
            debugPrint(error.toString());
            alertDialog(context, "Error: Data Save Fail");
          });
        } else {
          alertDialog(context, "User already register");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LoginAndSignupHeader(headerName: 'Signup'),
                CommonTextFormField(
                  controller: conUserName,
                  icon: Icons.person_outline,
                  inputType: TextInputType.name,
                  hintName: 'User Name',
                ),
                const SizedBox(height: 10.0),
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
                const SizedBox(height: 10.0),
                CommonTextFormField(
                  controller: conCPassword,
                  icon: Icons.lock,
                  hintName: 'Confirm Password',
                  isObscureText: true,
                ),
                Container(
                  margin: const EdgeInsets.all(30.0),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: signUp,
                    child: const Text(
                      'Signup',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Does you have account? '),
                    ElevatedButton(
                      child: const Text('Sign In'),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (Route<dynamic> route) => false,
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
