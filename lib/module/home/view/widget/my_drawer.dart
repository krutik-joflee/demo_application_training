// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:demo_application/module/home/view/screens/favourite_screen.dart';
import 'package:demo_application/module/home/view/screens/my_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/db_helper.dart';
import '../../controller/home_screen_controller.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final dbhelper = Databasehelper();
  HomeScreenController homeScreenController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: SingleChildScrollView(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(70.0),
            child: CircleAvatar(
              radius: 57,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(
                  "https://img.freepik.com/free-photo/tall-trees-forest-mountains-covered-with-fog_181624-11289.jpg?size=626&ext=jpg"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: ListTile(
              leading: const Icon(Icons.home),
              iconColor: Colors.black,
              title: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Home",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FavouriteScreen()));
              },
              child: ListTile(
                leading: const Icon(Icons.star),
                iconColor: Colors.yellow[700],
                title: const Text(
                  "Favourite",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: GestureDetector(
                  onTap: () async {
                    await showDialog(
                        context: context,
                        builder: (ok) => Padding(
                              padding: const EdgeInsets.all(8),
                              child: AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                content: Text(
                                    "Are you sure, you want to clear all data?"),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Cancel")),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          homeScreenController.serchcontroller
                                              .clear();
                                          await dbhelper.clearAllData();
                                          homeScreenController.listOfUser
                                              .clear();
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                        child: Text("Clear")),
                                  )
                                ],
                              ),
                            ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 330),
                    child: const Text(
                      "Clear data",
                      style: TextStyle(
                        shadows: [
                          Shadow(color: Colors.red, offset: Offset(0, -3))
                        ],
                        color: Colors.transparent,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.red,
                        decorationThickness: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
