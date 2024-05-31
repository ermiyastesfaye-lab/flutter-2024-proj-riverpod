import 'package:agri_app_2/providers/mycolor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agri_app_2/presentation/data/dummy_data.dart';
import 'package:agri_app_2/presentation/widget/logo.dart';
import 'package:agri_app_2/presentation/widget/menu_bar.dart';
import 'package:agri_app_2/presentation/widget/app_bar.dart';
import 'package:agri_app_2/presentation/widget/bottom_nav_bar.dart';

class FarmerOrderDisplay extends ConsumerWidget {
  const FarmerOrderDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myColor = ref.watch(myColorProvider);

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: LogoWidget(logo: logos[1]),
            ),
            const SizedBox(height: 16),
            Text(
              'Orders',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: myColor.tertiary,
              ),
            ),
            const SizedBox(height: 16), // Add spacing between Orders and list
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: 4,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  String itemName;
                  String imagePath;
                  Widget quantity;
                  switch (index) {
                    case 0:
                      itemName = 'Wheat(2)';
                      imagePath = 'assets/fruits.jpg';
                      quantity = SizedBox(
                          width: 150, child: QualityListItem(myColor: myColor));
                      break;
                    case 1:
                      itemName = 'Corn(2)';
                      imagePath = 'assets/fruits2.jpg';
                      quantity = SizedBox(
                          width: 150, child: QualityListItem(myColor: myColor));
                      break;
                    case 2:
                      itemName = 'Barley(2)';
                      imagePath = 'assets/agri.jpg';
                      quantity = SizedBox(
                          width: 150, child: QualityListItem(myColor: myColor));
                      break;
                    case 3:
                      itemName = 'Barley(2)';
                      imagePath = 'assets/agri.jpg';
                      quantity = SizedBox(
                          width: 150, child: QualityListItem(myColor: myColor));
                      break;
                    default:
                      itemName = 'Unknown';
                      imagePath = 'assets/agri2.jpg';
                      quantity = SizedBox(
                          width: 150, child: QualityListItem(myColor: myColor));
                  }
                  return Row(
                    children: [
                      Image.asset(
                        imagePath,
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  itemName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: myColor.tertiary),
                                ),
                                quantity
                              ],
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/marketPlace');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: myColor.secondary,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Sell'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
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

class QualityListItem extends StatefulWidget {
  const QualityListItem({super.key, required this.myColor});

  final MyColor myColor;

  @override
  State<QualityListItem> createState() => _QualityListItemState();
}

class _QualityListItemState extends State<QualityListItem> {
  int _quantity = 0; // Initial quality value

  void _incrementQuality() {
    setState(() {
      if (_quantity < 100) {
        _quantity++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quality: $_quantity',
          style: TextStyle(color: widget.myColor.tertiary),
        ),
        Row(
          children: [
            IconButton(
              onPressed: _incrementQuality,
              icon: const Icon(Icons.add_circle),
              color: widget.myColor.tertiary,
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  if (_quantity > 0) {
                    _quantity--;
                  }
                });
              },
              icon: const Icon(Icons.remove_circle),
              color: widget.myColor.tertiary,
            ),
          ],
        ),
      ],
    );
  }
}
