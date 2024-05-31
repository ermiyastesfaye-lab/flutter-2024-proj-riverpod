import 'package:agri_app_2/order/provider/order_provider.dart';
import 'package:agri_app_2/order/provider/order_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderNotifier extends StateNotifier<OrderState> {
  final OrderRepository orderRepository;

  OrderNotifier(this.orderRepository) : super(OrderInitialState());

  Future<void> fetchOrders() async {
    try {
      state = OrderLoadingState();
      final orders = await orderRepository.getOrders();
      state = OrderLoadedState(orders);
    } catch (error) {
      state = OrderErrorState(error.toString());
    }
  }
}

final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>(
  (ref) => OrderNotifier(ref.watch(orderRepositoryProvider)),
);
