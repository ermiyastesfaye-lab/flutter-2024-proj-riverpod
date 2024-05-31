import 'package:agri_app_2/presentation/data/dummy_data.dart';
import 'package:agri_app_2/presentation/widget/logo.dart';
import 'package:agri_app_2/presentation/widget/menu_bar.dart';
import 'package:agri_app_2/presentation/widget/order_management_list.dart';
import 'package:flutter/material.dart';
import 'package:agri_app_2/presentation/widget/app_bar.dart';
import 'package:agri_app_2/presentation/widget/bottom_nav_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agri_app_2/providers/mycolor_provider.dart';

import '../../crop/provider/crop_provider.dart'; // Import the crop provider

class MarketPlace extends ConsumerStatefulWidget {
  const MarketPlace({super.key});

  @override
  _MarketPlaceState createState() => _MarketPlaceState();
}

class _MarketPlaceState extends ConsumerState<MarketPlace> {
  @override
  void initState() {
    super.initState();
    // Fetch the crops when the widget is first built
    Future.microtask(() => ref.read(cropProvider.notifier).getOrderCrops());
  }

  @override
  Widget build(BuildContext context) {
    final myColor = ref.watch(myColorProvider);
    final cropState = ref.watch(cropProvider);

    return Scaffold(
      appBar: const AppBarWidget(
        userRole: '',
      ),
      drawer: const MenuBarWidget(
        userRole: '',
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        constraints: const BoxConstraints(maxWidth: 700.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: LogoWidget(logo: logos[1]),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Order',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: myColor.tertiary),
                ),
                const SizedBox(height: 30),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: cropState is CropLoadingState
                  ? Center(child: CircularProgressIndicator())
                  : cropState is CropLoadedState
                      ? GridView.count(
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 20,
                          crossAxisCount: 2,
                          children: cropState.crops
                              .map((crop) => OrderListManagement(crop: crop))
                              .toList(),
                        )
                      : cropState is CropErrorState
                          ? Center(child: Text('Error: ${cropState.error}'))
                          : Center(child: Text('No crops available')),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBarWidget(
        userRole: '',
      ),
    );
  }
}
