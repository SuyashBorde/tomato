import 'package:equatable/equatable.dart';
import 'restaurant.dart';

class CartItem extends Equatable {
  final MenuItem menuItem;
  final int quantity;

  const CartItem({
    required this.menuItem,
    required this.quantity,
  });

  double get totalPrice => menuItem.price * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      menuItem: menuItem,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object> get props => [menuItem, quantity];
}

class Cart extends Equatable {
  final List<CartItem> items;
  final Restaurant? restaurant;

  const Cart({
    this.items = const [],
    this.restaurant,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  double get deliveryFee => restaurant?.deliveryFee ?? 0;
  double get total => subtotal + deliveryFee;
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  Cart copyWith({
    List<CartItem>? items,
    Restaurant? restaurant,
  }) {
    return Cart(
      items: items ?? this.items,
      restaurant: restaurant ?? this.restaurant,
    );
  }

  @override
  List<Object?> get props => [items, restaurant];
}