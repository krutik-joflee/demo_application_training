// ignore_for_file: unused_local_variable

import 'package:demo_application/module/home/controller/home_screen_controller.dart';
import 'package:demo_application/module/home/view/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/db_helper.dart';
import '../../model/user_model.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final dbhelper = Databasehelper();
  HomeScreenController homeScreenController = Get.find();

  Future favouriteUser() async {
    final users = await dbhelper.favouriteuser();
  }

  @override
  void initState() {
    favouriteUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            "Favourite Screen",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: FutureBuilder<List<User>>(
            future: dbhelper.favouriteuser(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              List<User> userlist = snapshot.data ?? [];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: userlist.isEmpty
                    ? const Center(
                        child: Text('NO FAVOURITE USER FOUND'),
                      )
                    : ListView.separated(
                        itemCount: userlist.length,
                        itemBuilder: (context, index) {
                          var isFav = userlist[index].favourite == 0;
                          //FIRST NAME
                          String firstName = userlist[index].firstName ?? '';
                          //LAST NAME
                          String lastName = userlist[index].lastName ?? '';
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  var isRebuild = await Navigator.push<bool>(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UserProfileScreen(
                                                user: userlist[index],
                                              )));
                                  if (isRebuild ?? false) {
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  height: 80,
                                  decoration:
                                      BoxDecoration(color: Colors.grey[100]),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
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
                                        "$firstName $lastName",
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
              );
            }));
  }
}
