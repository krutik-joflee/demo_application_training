// ignore_for_file: prefer_const_constructors, deprecated_member_use, invalid_use_of_protected_member, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:demo_application/core/db_helper.dart';
import 'package:demo_application/module/home/controller/home_screen_controller.dart';
import 'package:demo_application/module/home/view/screens/user_profile_screen.dart';
import 'package:demo_application/module/home/view/widget/my_dailog.dart';
import 'package:demo_application/module/home/view/widget/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({Key? key}) : super(key: key);

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  late StreamSubscription internetconnection;
  bool isoffline = false;
  final dbhelper = Databasehelper();

  HomeScreenController homeScreenController = Get.put(HomeScreenController());

  @override
  initState() {
    internetconnection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.none) {
        await showDialog(
            context: context,
            builder: (ctx) =>
                Padding(padding: const EdgeInsets.all(15), child: MyDialog()));
        setState(() {
          isoffline = true;
        });
      } else if (result == ConnectivityResult.mobile) {
        print("NETWORK STATUS :- MOBILE DATA CONNECTED");
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.wifi) {
        print("NETWORK STATUS :- WIFI CONNECTED");
        setState(() {
          isoffline = false;
        });
      }
    });

    homeScreenController.getUserData();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    internetconnection.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        drawer: MyDrawer(),
        appBar: AppBar(
          toolbarHeight: 70,
          elevation: 0,
          title: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                child: TextField(
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.search),
                      hintText: "Search",
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              )),
          backgroundColor: Colors.grey[400],
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Obx(() => homeScreenController.isLoading.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : homeScreenController.listOfUser.isEmpty
                ? Center(
                    child: Text('NO USER FOUND'),
                  )
                : ListView.separated(
                    itemCount: homeScreenController.listOfUser.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            height: 80,
                            decoration: BoxDecoration(color: Colors.grey[100]),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: ListTile(
                                trailing: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Builder(builder: (context) {
                                    bool isFav = false;
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return Material(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              isFav = !isFav;
                                            });
                                          },
                                          child: Icon(Icons.star,
                                              color: isFav
                                                  ? Colors.yellow[700]
                                                  : Colors.grey[400]),
                                        ),
                                      );
                                    });
                                  }),
                                ),
                                leading: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UserProfileScreen(
                                                  user: homeScreenController
                                                      .listOfUser[index],
                                                )));
                                  },
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: NetworkImage(
                                      'https://img.freepik.com/free-photo/tall-trees-forest-mountains-covered-with-fog_181624-11289.jpg?size=626&ext=jpg',
                                    ),
                                  ),
                                ),
                                title: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UserProfileScreen(
                                                  user: homeScreenController
                                                      .listOfUser[index],
                                                )));
                                  },
                                  child: Text(
                                    (homeScreenController
                                                .listOfUser[index].firstName ??
                                            '') +
                                        " " +
                                        (homeScreenController
                                                .listOfUser[index].lastName ??
                                            ''),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                subtitle: Text(
                                    homeScreenController
                                            .listOfUser[index].email ??
                                        '',
                                    maxLines: 1),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                    },
                  )));
  }
}
