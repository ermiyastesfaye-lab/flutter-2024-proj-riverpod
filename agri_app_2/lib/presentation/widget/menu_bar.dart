import 'package:agri_app_2/auth/presentation/signup.dart';
import 'package:agri_app_2/presentation/data/dummy_data.dart';
import 'package:agri_app_2/presentation/screens/dash_board.dart';
import 'package:flutter/material.dart';

class MenuBarWidget extends StatelessWidget {
  const MenuBarWidget({super.key});

  @override
  Widget build(context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill, image: AssetImage('assets/fruits.jpg'))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [],
            ),
          ),
          ListTile(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => SignUp()));
              },
              leading: Icon(
                Icons.logout,
                size: 26,
                color: myColor.tertiary,
              ),
              title: const Text('Log out', style: TextStyle(fontSize: 20))),
          const Divider(
            color: Colors.black,
          ),
          ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const DashBoardScreen()));
              },
              leading: Icon(
                Icons.help,
                size: 26,
                color: myColor.tertiary,
              ),
              title: const Text('About App', style: TextStyle(fontSize: 20))),
        ],
      ),
    );
  }
}
