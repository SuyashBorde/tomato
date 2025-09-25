import 'package:flutter/material.dart';
import '../models/order.dart';

class NotificationService {
  static void showOrderPlacedNotification(BuildContext context, Order order) {
    final itemsList = order.cart.items.map((item) => '${item.menuItem.name} x${item.quantity}').join(', ');
    final restaurantName = order.cart.restaurant?.name ?? 'Restaurant';
    final total = order.cart.total.toStringAsFixed(0);
    final time = DateTime.now();
    final timeString = '${time.hour}:${time.minute.toString().padLeft(2, '0')}';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Order Placed Successfully! 🎉',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Order #${order.id} from $restaurantName'),
              Text('Items: $itemsList'),
              Text('Total: ₹$total • Time: $timeString'),
            ],
          ),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}