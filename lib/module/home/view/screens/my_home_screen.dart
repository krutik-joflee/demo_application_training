import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:demo_application/module/home/view/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../core/db_helper.dart';
import '../../controller/home_screen_controller.dart';
import '../widget/my_dailog.dart';
import '../widget/my_drawer.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({Key? key}) : super(key: key);
  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  ConnectivityResult connectivityResult = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final dbhelper = Databasehelper();
  HomeScreenController homeScreenController = Get.put(HomeScreenController());

  @override
  void initState() {
    initConnectivity();
    homeScreenController.getUserData();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      var developer;
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  RxBool isLoading = true.obs;
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(
      () {
        connectivityResult = result;
        if (ConnectivityResult.none == result) {
          showDialog(
            context: context,
            builder: (context) {
              return MyDialog();
            },
          );
          print("DATA NOT CONNECTED");
        } else if (ConnectivityResult.wifi == result ||
            ConnectivityResult.mobile == result) {
          setState(() {
            isLoading.value = true;
            homeScreenController.getUserData();
            isLoading.value = false;
            print("WIFI CONNECTED");
          });
        }
      },
    );
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
                  controller: homeScreenController.serchcontroller,
                  onChanged: (value) {
                    homeScreenController.searchUser(value);
                  },
                  decoration: const InputDecoration(
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
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Obx(
          () => homeScreenController.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : homeScreenController.listOfUser.isEmpty
                  ? const Center(
                      child: Text('NO USER FOUND'),
                    )
                  : ListView.separated(
                      controller: homeScreenController.scrollController,
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
        ));
  }
}
