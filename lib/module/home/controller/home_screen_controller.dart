// ignore_for_file: invalid_use_of_protected_member

import 'package:demo_application/core/api_services.dart';
import 'package:demo_application/module/home/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/db_helper.dart';

class HomeScreenController extends GetxController {
  RxList<User> listOfUser = <User>[].obs;
  RxList<User> favouriteList = <User>[].obs;

  RxBool isLoading = true.obs;
  RxBool isMoreDataAvailable = true.obs;

  final scrollController = ScrollController();

  final dbhelper = Databasehelper();

  TextEditingController serchcontroller = TextEditingController();

  void getUserData() async {
    isLoading.value = true;
    listOfUser.value = await dbhelper.getAllRecordFromDB();

    if (listOfUser.isEmpty) {
      await ApiServices.getHttp(listOfUser.length);
      listOfUser.value = await dbhelper.getAllRecordFromDB();
    }
    isLoading.value = false;
  }

  Future<void> searchUser(String value) async {
    if (value != '') {
      listOfUser.value = await dbhelper.search(value);
    } else {
      listOfUser.value = await dbhelper.search('');
    }
  }
}
