import 'package:agri_app_2/presentation/data/dummy_data.dart';
import 'package:agri_app_2/presentation/widget/logo.dart';
import 'package:agri_app_2/presentation/widget/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:agri_app_2/presentation/widget/app_bar.dart';
import 'package:agri_app_2/presentation/widget/menu_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agri_app_2/providers/mycolor_provider.dart';

class OrderPage extends ConsumerWidget {
  const OrderPage({super.key});

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
        body: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
              Opacity(
                opacity: 0.5,
                child: IgnorePointer(
                    child: Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 19, vertical: 10),
                        child: LogoWidget(logo: logos[1]),
                      ),
                    ),
                  ],
                )),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                padding: const EdgeInsets.all(15),
                height: 460,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color.fromARGB(255, 246, 246, 246),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Crop Details',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: myColor.tertiary),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Crop Name',
                            style: TextStyle(
                                fontSize: 16, color: myColor.tertiary),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          Text(
                            'Corn',
                            style: TextStyle(
                                fontSize: 20,
                                color: myColor.primary,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Crop Type',
                            style: TextStyle(
                                fontSize: 16, color: myColor.tertiary),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          Text(
                            'Zea mays',
                            style: TextStyle(
                                fontSize: 20,
                                color: myColor.primary,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Price(ETB)',
                            style: TextStyle(
                                fontSize: 16, color: myColor.tertiary),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          Text(
                            'ETB 200',
                            style: TextStyle(
                                fontSize: 20,
                                color: myColor.primary,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Quality',
                            style: TextStyle(
                                fontSize: 16, color: myColor.tertiary),
                          ),
                          const SizedBox(width: 150, child: QualityListItem()),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: SizedBox(
                          width: 300,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/marketPlace');
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: myColor.secondary
                                // Background color
                                ),
                            child: const Text(
                              'Order',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                      )
                    ]),
              ),
            ])),
        bottomNavigationBar: const BottomNavBarWidget(
          userRole: '',
        ));
  }
}

class QualityListItem extends ConsumerStatefulWidget {
  const QualityListItem({super.key});

  @override
  ConsumerState<QualityListItem> createState() => _QualityListItemState();
}

class _QualityListItemState extends ConsumerState<QualityListItem> {
  int _quantity = 0; // Initial quality value

  void _incrementQuality() {
    setState(() {
      if (_quantity < 100) {
        _quantity++;
      }
    });
  }

  void _decrementQuality() {
    setState(() {
      if (_quantity > 0) {
        _quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final myColor = ref.watch(myColorProvider);
    return ListTile(
      title: Row(
        children: [
          IconButton(
            onPressed: _decrementQuality,
            icon: const Icon(Icons.remove),
          ),
          Text(
            '$_quantity',
            style: TextStyle(
                fontSize: 20,
                color: myColor.primary,
                fontWeight: FontWeight.bold), // Text color
          ),
          IconButton(
            onPressed: _incrementQuality,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
