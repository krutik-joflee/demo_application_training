import 'package:demo_application/module/home/controller/home_screen_controller.dart';
import 'package:demo_application/module/home/view/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  HomeScreenController homeScreenController = Get.put(HomeScreenController());
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(
            () => homeScreenController.listOfUser.isEmpty
                ? const Center(
                    child: Text('NO USER FOUND'),
                  )
                : ListView.separated(
                    itemCount: homeScreenController.listOfUser.length,
                    itemBuilder: (context, index) {
                      final isFav =
                          homeScreenController.listOfUser[index].favourite == 0;
                      //FIRST NAME
                      String firstName =
                          homeScreenController.listOfUser[index].firstName ??
                              '';
                      //LAST NAME
                      String lastName =
                          homeScreenController.listOfUser[index].lastName ?? '';
                      return isFav
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
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
                            )
                          : Container();
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      final isFav =
                          homeScreenController.listOfUser[index].favourite == 0;
                      return isFav ? const Divider() : Container();
                    },
                  ),
          ),
        ));
  }
}
