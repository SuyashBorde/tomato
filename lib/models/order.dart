import 'package:equatable/equatable.dart';
import 'cart.dart';

enum OrderStatus { pending, confirmed, preparing, outForDelivery, delivered, cancelled }

class Order extends Equatable {
  final String id;
  final Cart cart;
  final OrderStatus status;
  final DateTime createdAt;
  final String? errorMessage;

  const Order({
    required this.id,
    required this.cart,
    required this.status,
    required this.createdAt,
    this.errorMessage,
  });

  Order copyWith({
    OrderStatus? status,
    String? errorMessage,
  }) {
    return Order(
      id: id,
      cart: cart,
      status: status ?? this.status,
      createdAt: createdAt,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [id, cart, status, createdAt, errorMessage];
}