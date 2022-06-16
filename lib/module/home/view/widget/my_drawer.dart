import 'package:demo_application/module/home/view/screens/favourite_screen.dart';
import 'package:demo_application/module/home/view/screens/my_home_screen.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(70.0),
          child: CircleAvatar(
            radius: 50,
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
          child: ListTile(
            leading: const Icon(Icons.star),
            iconColor: Colors.yellow[700],
            title: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FavouriteScreen()));
              },
              child: const Text(
                "Favourite",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
        const Spacer(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Text(
                "Clear data",
                style: TextStyle(
                  shadows: [Shadow(color: Colors.red, offset: Offset(0, -3))],
                  color: Colors.transparent,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.red,
                  decorationThickness: 1,
                ),
              ),
            ),
          ],
        )
      ],
    ));
  }
}
