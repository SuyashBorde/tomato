import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/restaurant.dart';
import '../repositories/restaurant_repository.dart';

// Events
abstract class RestaurantEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadRestaurants extends RestaurantEvent {}

class SelectRestaurant extends RestaurantEvent {
  final String restaurantId;
  SelectRestaurant(this.restaurantId);
  @override
  List<Object> get props => [restaurantId];
}

// States
abstract class RestaurantState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RestaurantInitial extends RestaurantState {}

class RestaurantLoading extends RestaurantState {}

class RestaurantLoaded extends RestaurantState {
  final List<Restaurant> restaurants;
  RestaurantLoaded(this.restaurants);
  @override
  List<Object> get props => [restaurants];
}

class RestaurantSelected extends RestaurantState {
  final Restaurant restaurant;
  RestaurantSelected(this.restaurant);
  @override
  List<Object> get props => [restaurant];
}

class RestaurantError extends RestaurantState {
  final String message;
  RestaurantError(this.message);
  @override
  List<Object> get props => [message];
}

// BLoC
class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final RestaurantRepository _repository;

  RestaurantBloc(this._repository) : super(RestaurantInitial()) {
    on<LoadRestaurants>(_onLoadRestaurants);
    on<SelectRestaurant>(_onSelectRestaurant);
  }

  Future<void> _onLoadRestaurants(LoadRestaurants event, Emitter<RestaurantState> emit) async {
    emit(RestaurantLoading());
    try {
      final restaurants = await _repository.getRestaurants();
      emit(RestaurantLoaded(restaurants));
    } catch (e) {
      emit(RestaurantError(e.toString()));
    }
  }

  Future<void> _onSelectRestaurant(SelectRestaurant event, Emitter<RestaurantState> emit) async {
    emit(RestaurantLoading());
    try {
      final restaurant = await _repository.getRestaurant(event.restaurantId);
      emit(RestaurantSelected(restaurant));
    } catch (e) {
      emit(RestaurantError(e.toString()));
    }
  }
}