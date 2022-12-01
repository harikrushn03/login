import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:login_and_signup_using_sqflite/Model/user_model.dart';
import 'package:login_and_signup_using_sqflite/Screens/login_screen.dart';
import 'package:login_and_signup_using_sqflite/commons/common_helper.dart';
import 'package:login_and_signup_using_sqflite/commons/common_text_form_field.dart';
import 'package:login_and_signup_using_sqflite/data_base_handler/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final formKey = GlobalKey<FormState>();
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();

  DataBaseHelper? dbHelper;

  UserModel? userModel;

  TextEditingController conUserName = TextEditingController();
  TextEditingController conEmail = TextEditingController();
  TextEditingController conPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserData();
    dbHelper = DataBaseHelper.instance;
  }

  Future<void> getUserData() async {
    final SharedPreferences sp = await pref;

    setState(() {
      String? data = sp.getString("user_data");

      if (data != null) {
        var decode = json.decode(data);
        userModel = UserModel.fromMap(decode);

        conUserName.text = userModel!.userName!;
        conEmail.text = userModel!.email!;
        conPassword.text = userModel!.password!;
      }
    });
  }

  update() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      UserModel user = UserModel(
        userID: userModel!.userID!,
        userName: conUserName.text,
        email: conEmail.text,
        password: conPassword.text,
      );

      await dbHelper!.updateUser(user).then((value) {
        if (value == 1) {
          updateSP(user: user, add: true).whenComplete(() {
            alertDialog(context, "Successfully Updated");
          });
        } else {
          alertDialog(context, "Error Update");
        }
      }).catchError((error) {
        debugPrint(error);
        alertDialog(context, "Error");
      });
    }
  }

  delete() async {
    await dbHelper!.deleteUser(userModel!.userID!).then((value) {
      if (value == 1) {
        alertDialog(context, "Successfully Deleted");
        updateSP(add: false).whenComplete(() {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (Route<dynamic> route) => false,
          );
        });
      }
    });
  }

  Future updateSP({UserModel? user, bool? add}) async {
    final SharedPreferences sp = await pref;
    if (add!) {
      sp.setString("user_data", json.encode(user!.toMap()));
    } else {
      sp.remove('user_data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: update,
                      child: const Text(
                        'Update Data',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: delete,
                      child: const Text(
                        'Delete User',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
