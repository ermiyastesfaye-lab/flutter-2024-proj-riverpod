import 'package:agri_app_2/presentation/data/dummy_data.dart';
import 'package:agri_app_2/presentation/widget/app_bar.dart';
import 'package:agri_app_2/presentation/widget/bottom_nav_bar.dart';
import 'package:agri_app_2/presentation/widget/logo.dart';
import 'package:agri_app_2/presentation/widget/menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a state provider for the order list
final orderListProvider = StateProvider<List<Order>>(
  (ref) => [
    Order(itemName: 'Wheat', quantity: 2, imagePath: 'assets/fruits.jpg'),
    Order(itemName: 'Corn', quantity: 2, imagePath: 'assets/fruits2.jpg'),
    Order(itemName: 'Barley', quantity: 2, imagePath: 'assets/agri.jpg'),
    Order(itemName: 'Barley', quantity: 2, imagePath: 'assets/agri.jpg'),
  ],
);

class Order {
  final String itemName;
  final int quantity;
  final String imagePath;

  Order(
      {required this.itemName,
      required this.quantity,
      required this.imagePath});
}

class FarmerOrderDisplay extends ConsumerWidget {
  const FarmerOrderDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(orderListProvider);

    return Scaffold(
      appBar: const AppBarWidget(),
      drawer: const MenuBarWidget(),
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
                  color: myColor.tertiary),
            ),
            const SizedBox(height: 16), // Add spacing between Orders and list
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return OrderItem(order: order, orderIndex: index);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBarWidget(),
    );
  }
}

class OrderItem extends ConsumerWidget {
  final Order order;
  final int orderIndex;

  const OrderItem({super.key, required this.order, required this.orderIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Image.asset(
          order.imagePath,
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
                    '${order.itemName}(${order.quantity})',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: myColor.tertiary),
                  ),
                  const SizedBox(width: 150, child: QualityListItem()),
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
  }
}

class QualityListItem extends ConsumerWidget {
  const QualityListItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderList = ref.watch(orderListProvider);
    final orderIndex = ref
        .watch(orderIndexProvider); // Assuming you have an orderIndexProvider

    if (orderIndex != null && orderIndex < orderList.length) {
      final order = orderList[orderIndex];
      return ListTile(
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                ref.read(orderIndexProvider.notifier).state = orderIndex - 1;
                ref.read(orderListProvider.notifier).update((state) {
                  final updatedOrder = state[orderIndex]
                      .copyWith(quantity: state[orderIndex].quantity - 1);
                  return state
                      .map((e) => e == state[orderIndex] ? updatedOrder : e)
                      .toList();
                });
              },
              icon: const Icon(Icons.remove),
            ),
            Text(
              '${order.quantity}',
              style: TextStyle(
                  fontSize: 20,
                  color: myColor.primary,
                  fontWeight: FontWeight.bold), // Text color
            ),
            IconButton(
              onPressed: () {
                ref.read(orderIndexProvider.notifier).state = orderIndex + 1;
                ref.read(orderListProvider.notifier).update((state) {
                  final updatedOrder = state[orderIndex]
                      .copyWith(quantity: state[orderIndex].quantity + 1);
                  return state
                      .map((e) => e == state[orderIndex] ? updatedOrder : e)
                      .toList();
                });
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

// Define an order index provider to track the current order being modified
final orderIndexProvider = StateProvider<int?>((ref) => null);

extension OrderCopy on Order {
  Order copyWith({int? quantity}) {
    return Order(
      itemName: itemName,
      quantity: quantity ?? this.quantity,
      imagePath: imagePath,
    );
  }
}
