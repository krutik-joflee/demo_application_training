// ignore_for_file: avoid_print, unused_local_variable, constant_identifier_names

import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../module/home/model/user_model.dart';

class Databasehelper {
  String dbName = "mydatabase.db";
  int dbversion = 1;
  String tablename = "myTable";

  static const columnId = "id";
  static const columnuserId = "userId";
  static const columncreatedAt = "createdAt";
  static const columnfirstName = "firstName";
  static const columnlastName = "lastName";
  static const columnemail = "email";
  static const columnupdatedat = "updatedAt";
  static const columnBio = "bio";
  static const columnFavourite = "favourite";

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initiateDatabase();
    return _database!;
  }

  initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    return await openDatabase(path, version: dbversion, onCreate: oncreat);
  }

  Future oncreat(Database db, int version) async {
    await db.execute('''
CREATE TABLE $tablename($columnId PRIMARY KEY , $columnfirstName TEXT, $columnlastName TEXT, $columnemail TEXT, $columncreatedAt TEXT, $columnupdatedat TEXT, $columnBio TEXT, $columnFavourite INTEGER)
''');
  }

  Future<void> insertAllUserToDB(List<User> usersList) async {
    final db = await database;
    for (int i = 0; i < usersList.length; i++) {
      Map<String, dynamic> userData = {
        Databasehelper.columnId: usersList[i].id,
        Databasehelper.columnfirstName: usersList[i].firstName,
        Databasehelper.columnlastName: usersList[i].lastName,
        Databasehelper.columnemail: usersList[i].email,
        Databasehelper.columncreatedAt: usersList[i].createdAt.toString(),
        Databasehelper.columnupdatedat: usersList[i].updatedAt.toString(),
      };
      print(usersList[i].firstName);
      await db.insert(tablename, userData);
    }
  }

  Future update(User usermodel) async {
    final db = await database;
    return await db.update(tablename,
        {columnBio: usermodel.bio, columnFavourite: usermodel.favourite},
        where: "$columnId=?", whereArgs: [usermodel.id]);
  }

  Future delete(int id) async {
    final db = await database;
    return await db.delete(tablename, where: columnId, whereArgs: [id]);
  }

  Future<List<User>> getAllRecordFromDB() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tablename);

    var tempList = List.generate(maps.length, (i) {
      return User(
          id: maps[i][columnId],
          createdAt: maps[i][columncreatedAt],
          firstName: maps[i][columnfirstName],
          lastName: maps[i][columnlastName],
          email: maps[i][columnemail],
          updatedAt: maps[i][columnupdatedat],
          bio: maps[i][columnBio],
          favourite: maps[i][columnFavourite]);
    });
    print(tempList);

    return tempList;
  }
}
