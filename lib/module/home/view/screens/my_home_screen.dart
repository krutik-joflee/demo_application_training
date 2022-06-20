// ignore_for_file: prefer_const_constructors, deprecated_member_use, invalid_use_of_protected_member, prefer_interpolation_to_compose_strings, unnecessary_this, recursive_getters

import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:demo_application/core/db_helper.dart';
import 'package:demo_application/module/home/controller/home_screen_controller.dart';
import 'package:demo_application/module/home/view/screens/user_profile_screen.dart';
import 'package:demo_application/module/home/view/widget/my_dailog.dart';
import 'package:demo_application/module/home/view/widget/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  late StreamSubscription internetconnection;
  bool isoffline = false;
  final dbhelper = Databasehelper();

  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  late String result;
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
        log("NETWORK STATUS :- MOBILE DATA CONNECTED");
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.wifi) {
        log("NETWORK STATUS :- WIFI CONNECTED");
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
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15,
                    spreadRadius: 5,
                  )
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                child: TextField(
                  onChanged: (value) {
                    dbhelper.search(value);
                  },
                  decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      hintText: "Search",
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                  cursorColor: Colors.black,
                ),
              )),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Obx(
          () => homeScreenController.isLoading.value
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
                        final isFav =
                            homeScreenController.listOfUser[index].favourite ==
                                0;
                        //FIRST NAME
                        String firstName =
                            homeScreenController.listOfUser[index].firstName ??
                                '';
                        //LAST NAME
                        String lastName =
                            homeScreenController.listOfUser[index].lastName ??
                                '';

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserProfileScreen(
                                              user: homeScreenController
                                                  .listOfUser[index],
                                            )));
                              },
                              child: Container(
                                height: 80,
                                decoration:
                                    BoxDecoration(color: Colors.grey[100]),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: ListTile(
                                    trailing: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.star,
                                          color: isFav
                                              ? Colors.yellow[700]
                                              : Colors.grey[400],
                                        )),
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.grey[800],
                                      radius: 25,
                                      child: Text(
                                        '${firstName[0]}${lastName[0]}',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                    title: Text(
                                      (firstName) + " " + (lastName),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                        homeScreenController
                                            .listOfUser[index].email
                                            .toString(),
                                        maxLines: 1),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                    ),
        ));
  }
}
