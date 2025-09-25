import 'package:equatable/equatable.dart';

class Restaurant extends Equatable {
  final String id;
  final String name;
  final String image;
  final double rating;
  final int deliveryTime;
  final double deliveryFee;
  final List<MenuItem> menu;

  const Restaurant({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.menu,
  });

  @override
  List<Object> get props => [id, name, image, rating, deliveryTime, deliveryFee, menu];
}

class MenuItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  @override
  List<Object> get props => [id, name, description, price, image];
}