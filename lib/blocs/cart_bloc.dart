import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/cart.dart';
import '../models/restaurant.dart';

// Events
abstract class CartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddToCart extends CartEvent {
  final MenuItem menuItem;
  final Restaurant restaurant;
  AddToCart(this.menuItem, this.restaurant);
  @override
  List<Object> get props => [menuItem, restaurant];
}

class RemoveFromCart extends CartEvent {
  final MenuItem menuItem;
  RemoveFromCart(this.menuItem);
  @override
  List<Object> get props => [menuItem];
}

class UpdateQuantity extends CartEvent {
  final MenuItem menuItem;
  final int quantity;
  UpdateQuantity(this.menuItem, this.quantity);
  @override
  List<Object> get props => [menuItem, quantity];
}

class ClearCart extends CartEvent {}

// States
class CartState extends Equatable {
  final Cart cart;
  CartState(this.cart);
  @override
  List<Object> get props => [cart];
}

// BLoC
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState(const Cart())) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<ClearCart>(_onClearCart);
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final currentItems = List<CartItem>.from(state.cart.items);
    final existingIndex = currentItems.indexWhere((item) => item.menuItem.id == event.menuItem.id);
    
    if (existingIndex >= 0) {
      currentItems[existingIndex] = currentItems[existingIndex].copyWith(
        quantity: currentItems[existingIndex].quantity + 1,
      );
    } else {
      currentItems.add(CartItem(menuItem: event.menuItem, quantity: 1));
    }
    
    emit(CartState(state.cart.copyWith(items: currentItems, restaurant: event.restaurant)));
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    final currentItems = state.cart.items.where((item) => item.menuItem.id != event.menuItem.id).toList();
    emit(CartState(state.cart.copyWith(items: currentItems)));
  }

  void _onUpdateQuantity(UpdateQuantity event, Emitter<CartState> emit) {
    if (event.quantity <= 0) {
      add(RemoveFromCart(event.menuItem));
      return;
    }
    
    final currentItems = List<CartItem>.from(state.cart.items);
    final existingIndex = currentItems.indexWhere((item) => item.menuItem.id == event.menuItem.id);
    
    if (existingIndex >= 0) {
      currentItems[existingIndex] = currentItems[existingIndex].copyWith(quantity: event.quantity);
      emit(CartState(state.cart.copyWith(items: currentItems)));
    }
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(CartState(const Cart()));
  }
}