import 'package:agri_app_2/presentation/data/dummy_data.dart';
import 'package:agri_app_2/presentation/widget/app_bar.dart';
import 'package:agri_app_2/presentation/widget/bottom_nav_bar.dart';
import 'package:agri_app_2/presentation/widget/category.dart';
import 'package:agri_app_2/presentation/widget/crop_list.dart';
import 'package:agri_app_2/presentation/widget/menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashBoardScreen extends ConsumerWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const AppBarWidget(),
      drawer: const MenuBarWidget(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                width: 350,
                height: 35,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter Crop Name',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: myColor.primary),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color.fromARGB(255, 246, 246, 246),
              ),
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Categories',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: myColor.tertiary,
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (final category in availableCategories1)
                              CategoryWidget(category: category)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (final category in availableCategories2)
                              CategoryWidget(
                                category: category,
                              )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      width: 380,
                      decoration: BoxDecoration(
                        color: myColor.secondary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Exclusive deal',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            'Discover our latest products now',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 50),
                          Row(
                            children: [
                              const Text(
                                'Check it out',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/marketPlace');
                                },
                                icon: const Icon(Icons.arrow_forward,
                                    color: Colors.white),
                                label: const Text(''),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const Center(
                    child: Icon(
                      Icons.more_horiz,
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Top picks',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: myColor.tertiary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (final crop in availableCrops)
                        Expanded(child: CropListWidget(crop: crop))
                    ],
                  )
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