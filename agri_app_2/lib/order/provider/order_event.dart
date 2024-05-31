// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:agri_app_2/order/model/order_model.dart';
import 'package:agri_app_2/order/model/update_order_model.dart';

abstract class OrderEvent {
  const OrderEvent();
}

class LoadOrdersEvent extends OrderEvent {
  const LoadOrdersEvent();
}

class CreateOrderEvent extends OrderEvent {
  final Order order;

  const CreateOrderEvent(this.order);
}

class DeleteOrderEvent extends OrderEvent {
  final String? orderId;

  const DeleteOrderEvent(this.orderId);
}

class UpdateOrderEvent extends OrderEvent {
  final String orderId;
  final UpdateOrderDto order;

  UpdateOrderEvent({required this.orderId, required this.order});

  List<Object> get props => [orderId, order];
}

class GetOrdersByIdEvent extends OrderEvent {
  final int orderId;
  GetOrdersByIdEvent({
    required this.orderId,
  });
}

class GetOrdersEvent extends OrderEvent {
  const GetOrdersEvent();
}

