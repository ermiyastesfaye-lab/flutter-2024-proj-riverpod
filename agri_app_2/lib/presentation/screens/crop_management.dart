import 'package:agri_app_2/presentation/data/dummy_data.dart';
import 'package:agri_app_2/presentation/widget/app_bar.dart';
import 'package:agri_app_2/presentation/widget/bottom_nav_bar.dart';
import 'package:agri_app_2/presentation/widget/crop_management_list.dart';
import 'package:agri_app_2/presentation/widget/logo.dart';
import 'package:agri_app_2/presentation/widget/menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agri_app_2/providers/mycolor_provider.dart';

import 'package:agri_app_2/presentation/model/crop_list.dart';

class CropListWidget extends ConsumerWidget {
  const CropListWidget({super.key, required this.crop});

  final CropList crop;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myColor = ref.watch(myColorProvider);

    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Center(
              child: Image.asset(
                crop.image,
                width: 150,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                crop.price,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: myColor.tertiary,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/marketPlace');
                },
                icon: Icon(
                  Icons.shopping_cart,
                  color: myColor.tertiary,
                ),
                label: const Text(''),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// crop_management.dart

class CropMangement extends ConsumerWidget {
  const CropMangement({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myColor = ref.watch(myColorProvider); // Watch the myColorProvider

    // final availableCrop2 = ref.watch(cropProvider); // Watch the cropProvider

    return Scaffold(
      appBar: const AppBarWidget(),
      drawer: const MenuBarWidget(),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        constraints: const BoxConstraints(maxWidth: 700.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: LogoWidget(logo: logos[0]),
            ),
            Center(
              child: SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/addCrop');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: myColor.secondary,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 15),
                      Text(
                        'Add',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'List',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: myColor.tertiary,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: GridView.count(
                crossAxisSpacing: 15,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: [
                  for (final crop in availableCrop2)
                    CropListManagement(crop: crop)
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBarWidget(),
    );
  }
}
