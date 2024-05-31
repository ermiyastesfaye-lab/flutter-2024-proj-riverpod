import 'package:agri_app_2/order/model/order_model.dart';
import 'package:equatable/equatable.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitialState extends OrderState {}

class OrderLoadingState extends OrderState {}

class OrderLoadedState extends OrderState {
  final List<Order> orders;

  const OrderLoadedState(this.orders);

  @override
  List<Object?> get props => [orders];
}

class OrderErrorState extends OrderState {
  final String message;

  const OrderErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class OrderSuccessState extends OrderState {
  final String message;

  const OrderSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}

class OrdersLoadingState extends OrderState {
  const OrdersLoadingState();

  @override
  List<Object?> get props => [];
}