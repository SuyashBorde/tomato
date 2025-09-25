import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/order.dart';

// Events
abstract class HistoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadOrderHistory extends HistoryEvent {}

class AddOrderToHistory extends HistoryEvent {
  final Order order;

  AddOrderToHistory(this.order);

  @override
  List<Object> get props => [order];
}

// States
abstract class HistoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<Order> orders;

  HistoryLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final List<Order> _orders = [];

  HistoryBloc() : super(HistoryInitial()) {
    on<LoadOrderHistory>(_onLoadOrderHistory);
    on<AddOrderToHistory>(_onAddOrderToHistory);
  }

  void _onLoadOrderHistory(LoadOrderHistory event, Emitter<HistoryState> emit) {
    emit(HistoryLoaded(List.from(_orders.reversed)));
  }

  void _onAddOrderToHistory(AddOrderToHistory event, Emitter<HistoryState> emit) {
    _orders.add(event.order);
    emit(HistoryLoaded(List.from(_orders.reversed)));
  }
}