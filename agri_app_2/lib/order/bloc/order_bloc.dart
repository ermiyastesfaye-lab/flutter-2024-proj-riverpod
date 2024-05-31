import 'package:agri_app_2/order/data_provider/order_data_provider.dart';
import 'package:agri_app_2/order/model/order_model.dart';
import 'package:agri_app_2/order/model/update_order_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

final orderProvider =
    StateNotifierProvider<OrderNotifier, AsyncValue<List<Order>>>(
  (ref) => OrderNotifier(ref.watch(orderRepositoryProvider)),
);

class OrderNotifier extends StateNotifier<AsyncValue<List<Order>>> {
  final OrderRepository _orderRepository;

  OrderNotifier(this._orderRepository) : super(const AsyncValue.loading());

  Future<void> fetchOrders() async {
    try {
      final orders = await _orderRepository.getOrders();
      state = AsyncValue.data(orders);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> createOrder(Order order) async {
    try {
      state = const AsyncValue.loading();
      await _orderRepository.createOrder(order);
      await fetchOrders();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await _orderRepository.deleteOrder(orderId);
      await fetchOrders();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateOrder(String orderId, UpdateOrderDto updatedOrder) async {
    try {
      await _orderRepository.updateOrder(orderId, updatedOrder);
      await fetchOrders();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> getOrderById(int orderId) async {
    try {
      final orders = await _orderRepository.getOrderById(orderId);
      state = AsyncValue.data(orders);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

// Define the abstract repository interface
abstract class OrderRepository {
  Future<Order> createOrder(Order order);
  Future<void> deleteOrder(String? orderId);
  Future<UpdateOrderDto> updateOrder(String orderId, UpdateOrderDto order);
  Future<List<Order>> getOrderById(int orderId);
  Future<List<Order>> getOrders();
}

// Define the concrete repository implementation
class ConcreteOrderRepository implements OrderRepository {
  final OrderDataProvider orderDataProvider;

  ConcreteOrderRepository({
    required this.orderDataProvider,
  });

  @override
  Future<Order> createOrder(Order order) async {
    return await orderDataProvider.createOrder(order);
  }

  @override
  Future<void> deleteOrder(String? orderId) async {
    return await orderDataProvider.deleteOrder(orderId);
  }

  @override
  Future<UpdateOrderDto> updateOrder(
      String orderId, UpdateOrderDto order) async {
    return await orderDataProvider.updateOrder(orderId, order);
  }

  @override
  Future<List<Order>> getOrderById(int orderId) async {
    return await orderDataProvider.getOrderById(orderId);
  }

  @override
  Future<List<Order>> getOrders() async {
    return await orderDataProvider.getOrders();
  }
}

// Define the repository provider
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  // Replace with your actual data provider provider
  return ConcreteOrderRepository(
      orderDataProvider: ref.watch(orderDataProviderProvider));
});

// Define the data provider provider
final orderDataProviderProvider = Provider<OrderDataProvider>((ref) {
  // Replace with your actual data provider implementation
  final dio = Dio();
  final sharedPreferences = ref.watch(
      sharedPreferencesProvider); // Assuming you have a sharedPreferencesProvider
  return OrderDataProvider(dio, sharedPreferences as SharedPreferences);
});

// Define the sharedPreferencesProvider (if you haven't already)
// Define the sharedPreferencesProvider
final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences
      .getInstance(); // Get an instance of SharedPreferences
});
