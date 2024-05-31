import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agri_app_2/presentation/data/dummy_data.dart';
import 'package:agri_app_2/presentation/widget/logo.dart';
import 'package:agri_app_2/presentation/widget/app_bar.dart';
import 'package:agri_app_2/presentation/widget/bottom_nav_bar.dart';
import 'package:agri_app_2/presentation/widget/menu_bar.dart';
import 'package:agri_app_2/presentation/widget/order_display.dart';
import 'package:agri_app_2/providers/mycolor_provider.dart';
import 'package:agri_app_2/order/provider/order_state.dart';
import 'package:agri_app_2/order/provider/order_notifier.dart';

class OrderDisplayScreen extends ConsumerStatefulWidget {
  const OrderDisplayScreen({super.key});

  @override
  _OrderDisplayScreenState createState() => _OrderDisplayScreenState();
}

class _OrderDisplayScreenState extends ConsumerState<OrderDisplayScreen> {
  String _userRole = '';

  Future<void> _getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userRole =
          prefs.getString('role') ?? 'BUYER'; // Default to 'BUYER' if not found
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserRole();
    ref.read(orderProvider.notifier).fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    final myColor = ref.watch(myColorProvider);
    final orderState = ref.watch(orderProvider);

    return Scaffold(
      appBar: AppBarWidget(userRole: _userRole),
      drawer: MenuBarWidget(userRole: _userRole),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: LogoWidget(logo: logos[1]),
              ),
              const SizedBox(height: 40),
              if (orderState is OrderLoadingState)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else if (orderState is OrderErrorState)
                Center(
                  child: Text('Error: ${orderState.message}'),
                )
              else if (orderState is OrderLoadedState)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: myColor.tertiary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    for (final order in orderState.orders)
                      OrderDisplayWidget(order: order)
                  ],
                )
              else if (orderState is OrderInitialState)
                const Center(
                  child: Text('No orders found'),
                )
              else
                Center(
                  child: Text('State: $orderState'),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBarWidget(userRole: _userRole),
    );
  }
}
