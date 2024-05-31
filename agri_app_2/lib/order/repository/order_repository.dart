// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:agri_app_2/order/data_provider/order_data_provider.dart';
import 'package:agri_app_2/order/model/order_model.dart';
import 'package:agri_app_2/order/model/update_order_model.dart';

abstract class OrderRepository {
  Future<Order> createOrder(Order order);
  Future<void> deleteOrder(String? orderId);
  Future<UpdateOrderDto> updateOrder(String orderId, UpdateOrderDto order);
  Future<List<Order>> getOrderById(int orderId);
  Future<List<Order>> getOrders();
}

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
