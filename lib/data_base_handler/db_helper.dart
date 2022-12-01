import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login_and_signup_using_sqflite/Model/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DataBaseHelper {
  static Database? _dataBase;

  static const String dbName = 'test.db';
  static const String tableUser = 'user';
  static const int version = 1;

  static const String cUserID = 'user_id';
  static const String cUserName = 'user_name';
  static const String cEmail = 'email';
  static const String cPassword = 'password';

  DataBaseHelper._privateConstructor();

  static final DataBaseHelper instance = DataBaseHelper._privateConstructor();

  Future<Database> get dataBase async {
    if (_dataBase != null) {
      return _dataBase!;
    }
    _dataBase = await initDb();
    return _dataBase!;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);
    var db = await openDatabase(path, version: version, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int intVersion) async {
    await db.execute("CREATE TABLE $tableUser ($cUserID INTEGER PRIMARY KEY, $cUserName TEXT, $cEmail TEXT, $cPassword TEXT)");
  }

  Future<int> saveData(UserModel user) async {
    Database dbClient = await instance.dataBase;
    return await dbClient.insert(tableUser, user.toMap());
  }

  Future<String> getLastId() async {
    Database dbClient = await instance.dataBase;
    final data = await dbClient.rawQuery('SELECT * FROM $tableUser');
    if (data.isEmpty) {
      return "1";
    } else {
      final dbUserId = data.last[cUserID];
      return (int.parse(dbUserId.toString()) + 1).toString();
    }
  }

  Future<bool> checkUser(String email) async {
    var dbClient = await instance.dataBase;
    var res = await dbClient.rawQuery("SELECT * FROM $tableUser WHERE $cEmail = '$email'");

    if (res.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future getLoginUser(String email, String password) async {
    var dbClient = await instance.dataBase;
    var res = await dbClient.rawQuery("SELECT * FROM $tableUser WHERE $cEmail = '$email' AND $cPassword = '$password'");

    if (res.isNotEmpty) {
      return (res.first);
    }

    return null;
  }

  Future<int> updateUser(UserModel user) async {
    var dbClient = await instance.dataBase;
    var res = await dbClient.update(tableUser, user.toMap(), where: '$cUserID = ?', whereArgs: [user.userID]);
    return res;
  }

  Future<int> deleteUser(int userId) async {
    var dbClient = await instance.dataBase;
    var res = await dbClient.delete(tableUser, where: '$cUserID = ?', whereArgs: [userId]);
    return res;
  }
}
