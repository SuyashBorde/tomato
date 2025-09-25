import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/order.dart';
import '../models/cart.dart';
import '../repositories/order_repository.dart';

// Events
abstract class OrderEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PlaceOrder extends OrderEvent {
  final Cart cart;
  PlaceOrder(this.cart);
  @override
  List<Object> get props => [cart];
}

class TrackOrder extends OrderEvent {
  final String orderId;
  TrackOrder(this.orderId);
  @override
  List<Object> get props => [orderId];
}

// States
abstract class OrderState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderPlacing extends OrderState {}

class OrderPlaced extends OrderState {
  final Order order;
  OrderPlaced(this.order);
  @override
  List<Object> get props => [order];
}

class OrderTracking extends OrderState {
  final Order order;
  OrderTracking(this.order);
  @override
  List<Object> get props => [order];
}

class OrderError extends OrderState {
  final String message;
  OrderError(this.message);
  @override
  List<Object> get props => [message];
}

// BLoC
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _repository;

  OrderBloc(this._repository) : super(OrderInitial()) {
    on<PlaceOrder>(_onPlaceOrder);
    on<TrackOrder>(_onTrackOrder);
  }

  Future<void> _onPlaceOrder(PlaceOrder event, Emitter<OrderState> emit) async {
    emit(OrderPlacing());
    try {
      final order = await _repository.placeOrder(event.cart);
      emit(OrderPlaced(order));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onTrackOrder(TrackOrder event, Emitter<OrderState> emit) async {
    try {
      final order = await _repository.getOrderStatus(event.orderId);
      emit(OrderTracking(order));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}