// ignore_for_file: invalid_use_of_protected_member

import 'package:demo_application/core/api_services.dart';
import 'package:demo_application/module/home/model/user_model.dart';
import 'package:get/get.dart';

import '../../../core/db_helper.dart';

class HomeScreenController extends GetxController {
  RxList<User> listOfUser = <User>[].obs;

  RxBool isLoading = true.obs;

  final dbhelper = Databasehelper();

  void getUserData() async {
    isLoading.value = true;
    listOfUser.value = await dbhelper.getAllRecordFromDB();

    if (listOfUser.isEmpty) {
      await ApiServices.getHttp();
      listOfUser.value = await dbhelper.getAllRecordFromDB();
    }
    isLoading.value = false;
  }
}
