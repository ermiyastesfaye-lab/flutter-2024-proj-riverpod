import 'package:agri_app_2/crop/presentation/crop_management.dart';
import 'package:agri_app_2/presentation/screens/dash_board.dart';

import 'package:flutter/material.dart';

class BottomNavBarWidget extends StatefulWidget {
  const BottomNavBarWidget({super.key});

  @override
  State<BottomNavBarWidget> createState() => _BottomNavBarWidgetState();
}

class _BottomNavBarWidgetState extends State<BottomNavBarWidget> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        if (index == 0) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const DashBoardScreen()));
        } else if (index == 1) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CropMangement()));
        } /** {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const MarketPlace()));
        } **/
      },
      currentIndex: _selectedIndex, // Set the current index
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_filled,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.agriculture),
          label: 'Crops',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shop_two),
          label: 'Market',
        ),
      ],
      selectedItemColor: Colors.black, // Active color for the selected item
    );
  }
}
