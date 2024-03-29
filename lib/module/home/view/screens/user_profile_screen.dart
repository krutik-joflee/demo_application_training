// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, sort_child_properties_last, unnecessary_null_comparison, unused_local_variable, use_build_context_synchronously

import 'package:demo_application/core/db_helper.dart';
import 'package:demo_application/module/home/controller/user_profile_screen_controller.dart';
import 'package:demo_application/module/home/view/widget/profile_data_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/home_screen_controller.dart';
import '../../model/user_model.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({
    Key? key,
    required this.user,
  }) : super(key: key);
  final User user;

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  UserProfileScreenController userProfileScreenController =
      Get.put(UserProfileScreenController());
  HomeScreenController homeScreenController = Get.find();

  final dbhelper = Databasehelper();
  bool isFav = false;

  TextEditingController biocontroller = TextEditingController();

  @override
  void initState() {
    biocontroller.text = widget.user.bio ?? "";
    isFav = widget.user.favourite == 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () async {
                await userProfileScreenController.insertdata(
                    id: widget.user.id ?? "",
                    bio: biocontroller.text,
                    favourite: isFav == true ? 0 : 1);
                homeScreenController.getUserData();
                Navigator.pop(context, true);
              },
              icon: Icon(Icons.arrow_back_ios_rounded)),
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Builder(builder: (context) {
                return StatefulBuilder(builder: (context, setState) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        isFav = !isFav;
                      });
                    },
                    icon: Icon(Icons.star,
                        color: isFav ? Colors.yellow[700] : Colors.grey[400]),
                  );
                });
              }),
            )
          ],
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                    height: 150,
                    child: CircleAvatar(
                      radius: 55,
                      child: Text(
                        "${widget.user.firstName![0]}${widget.user.lastName![0]}",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                      backgroundColor: Colors.grey[800],
                    )),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(left: 30, top: 6),
                        child: ProfileDataViewWidget(
                          title: "First Name",
                          value: widget.user.firstName ?? "",
                        )),
                  ),
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.only(top: 6, left: 5),
                          child: ProfileDataViewWidget(
                            title: 'Last Name',
                            value: widget.user.lastName ?? '',
                          )))
                ],
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 30, top: 30),
                  child: ProfileDataViewWidget(
                    title: 'Email',
                    value: widget.user.email ?? '',
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 25, right: 25),
                child: Card(
                  child: TextFormField(
                    maxLines: 3,
                    controller: biocontroller,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        labelText: 'Bio',
                        labelStyle: TextStyle(color: Colors.black)),
                    cursorColor: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 20, left: 25, right: 25, top: 210),
                child: InkWell(
                  onTap: () async {
                    await userProfileScreenController.insertdata(
                        id: widget.user.id ?? "",
                        bio: biocontroller.text,
                        favourite: isFav == true ? 0 : 1);
                    homeScreenController.getUserData();
                    Navigator.pop(context, true);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    child: Center(
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.black,
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
