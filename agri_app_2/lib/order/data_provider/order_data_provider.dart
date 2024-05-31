import 'package:agri_app_2/order/model/order_model.dart';
import 'package:agri_app_2/order/model/update_order_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDataProvider {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  OrderDataProvider(this.dio, this.sharedPreferences);

  Future<Map<String, String>> _authenticatedHeaders() async {
    final token = sharedPreferences.getString('token');

    if (token == null) {
      throw Exception('Missing token in local storage.');
    }

    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json', // Assuming JSON content type
    };
  }

  Future<Order> createOrder(Order order) async {
    try {
      final headers = await _authenticatedHeaders();
      final response = await dio.post('http://localhost:3000/orders',
          data: order.toJson(), options: Options(headers: headers));

      if (response.statusCode == 201) {
        final data = response.data;
        return Order.fromJson(data);
      } else {
        print("Failed to create order");
        throw Exception('Failed to create Order');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteOrder(String? orderId) async {
    try {
      final headers = await _authenticatedHeaders();
      final response = await dio.delete('http://localhost:3000/orders/$orderId',
          options: Options(headers: headers));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete Order');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<UpdateOrderDto> updateOrder(
      String orderId, UpdateOrderDto order) async {
    try {
      final headers = await _authenticatedHeaders();
      final response = await dio.patch('http://localhost:3000/orders/$orderId',
          data: order.toJson(), options: Options(headers: headers));

      if (response.statusCode == 200) {
        final data = response.data;
        print(data);
        return UpdateOrderDto.fromJson(data);
      } else {
        print("error");
        throw Exception('Failed to update Order');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Order>> getOrderById(int orderId) async {
    try {
      final headers = await _authenticatedHeaders();
      final response = await dio.get(
        'http://localhost:3000/orders/$orderId',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((orderJson) => Order.fromJson(orderJson)).toList();
      } else {
        throw Exception('Failed to get Orders for user');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Order>> getOrders() async {
    try {
      final headers = await _authenticatedHeaders();
      final response = await dio.get('http://localhost:3000/orders',
          options: Options(headers: headers));

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data; // Directly use response.data
        return data.map((json) => Order.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get Orders');
      }
    } catch (error) {
      print('Error: $error');
      rethrow;
    }
  }
}
