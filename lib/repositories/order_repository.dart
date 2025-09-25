import '../models/order.dart';
import '../models/cart.dart';

abstract class OrderRepository {
  Future<Order> placeOrder(Cart cart);
  Future<Order> getOrderStatus(String orderId);
}

class MockOrderRepository implements OrderRepository {
  final Map<String, Order> _orders = {};

  @override
  Future<Order> placeOrder(Cart cart) async {
    await Future.delayed(const Duration(seconds: 2));
    
    // Simulate random order failure
    if (DateTime.now().millisecond % 10 == 0) {
      throw Exception('Payment failed. Please try again.');
    }

    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      cart: cart,
      status: OrderStatus.confirmed,
      createdAt: DateTime.now(),
    );
    
    _orders[order.id] = order;
    return order;
  }

  @override
  Future<Order> getOrderStatus(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final order = _orders[orderId];
    if (order == null) throw Exception('Order not found');
    return order;
  }
}