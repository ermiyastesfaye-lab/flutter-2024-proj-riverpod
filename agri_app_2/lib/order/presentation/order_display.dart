import 'package:agri_app_2/order/data_provider/order_data_provider.dart';
import 'package:agri_app_2/order/model/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

// Provider for the OrderDataProvider
final orderDataProviderProvider = Provider<OrderDataProvider>((ref) {
  final dio = Dio();
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return OrderDataProvider(dio, sharedPreferences);
});

// Provider for SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  return SharedPreferences.getInstance() as SharedPreferences;
});

class OrderDisplayScreen extends ConsumerWidget {
  const OrderDisplayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the orderDataProviderProvider to get the OrderDataProvider instance
    final orderDataProvider = ref.watch(orderDataProviderProvider);

    // Use the orderDataProvider to fetch orders asynchronously
    final ordersAsync = ref.watch(FutureProvider<List<Order>>(
      (ref) => orderDataProvider.getOrders(),
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order List'),
      ),
      body: ordersAsync.when(
        data: (orders) {
          return orders.isEmpty
              ? const Center(child: Text('No orders yet.'))
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return OrderDisplayWidget(order: order);
                  },
                );
        },
        error: (error, stackTrace) {
          return Center(child: Text('Error: $error'));
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class OrderDisplayWidget extends StatelessWidget {
  final Order order;

  const OrderDisplayWidget({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: ${order.orderId}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text('Crop ID: ${order.cropId}'),
            const SizedBox(height: 8.0),
            Text('Quantity: ${order.quantity}'),
            // Add more fields as needed from the Order model
          ],
        ),
      ),
    );
  }
}
