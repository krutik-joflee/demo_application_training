import 'dart:convert';
import 'dart:developer';
import 'package:demo_application/module/home/model/user_model.dart';
import 'package:dio/dio.dart';

import 'db_helper.dart';

abstract class ApiServices {
  static Future<void> getHttp() async {
    final dbhelper = Databasehelper();

    try {
      var response = await Dio()
          .get('https://verified-mammal-79.hasura.app/api/rest/users/0');
      List<User> listOfUser =
          welcomeFromJson(jsonEncode(response.data)).users ?? [];
      await dbhelper.insertAllUserToDB(listOfUser);
      print(listOfUser);
    } catch (e, st) {
      log("Error in getall users", error: e, stackTrace: st);
      return;
    }
  }
}
