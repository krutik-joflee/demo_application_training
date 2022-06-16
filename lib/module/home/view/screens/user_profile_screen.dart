// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, sort_child_properties_last, unnecessary_null_comparison, unused_local_variable

import 'package:demo_application/core/db_helper.dart';
import 'package:demo_application/module/home/view/widget/profile_data_view_widget.dart';
import 'package:flutter/material.dart';

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
  final dbhelper = Databasehelper();

  TextEditingController biocontroller = TextEditingController();
  @override
  void initState() {
    if (widget.user != null) {
      biocontroller.text = widget.user.bio ?? "";
    } else {
      biocontroller.text = "";
    }
    super.initState();
  }

  Future<void> insertdata({required String bio}) async {
    Map<String, dynamic> userData = {Databasehelper.columnBio: bio};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(
                Icons.star,
                color: Colors.yellow[700],
              ),
            )
          ],
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                height: 150,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://img.freepik.com/free-photo/tall-trees-forest-mountains-covered-with-fog_181624-11289.jpg?size=626&ext=jpg"),
                  radius: 60,
                ),
              ),
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
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 25, right: 25),
              child: InkWell(
                onTap: () {
                  if (widget.user != null) {
                    dbhelper.update(widget.user..bio = biocontroller.text);
                  } else {
                    insertdata(bio: biocontroller.text);
                  }
                  Navigator.pop(context);
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
        ));
  }
}
