import 'package:demo_application/module/home/controller/home_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  HomeScreenController homeScreenController = Get.find();

  @override
  void initState() {
    homeScreenController.getUserData();
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
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 13),
          child: Icon(
            Icons.star,
            color: Colors.yellow[700],
          ),
        )
      ],
    ));
  }
}
