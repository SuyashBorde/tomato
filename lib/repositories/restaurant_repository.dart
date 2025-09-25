import '../models/restaurant.dart';

abstract class RestaurantRepository {
  Future<List<Restaurant>> getRestaurants();
  Future<Restaurant> getRestaurant(String id);
}

class MockRestaurantRepository implements RestaurantRepository {
  @override
  Future<List<Restaurant>> getRestaurants() async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockRestaurants;
  }

  @override
  Future<Restaurant> getRestaurant(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockRestaurants.firstWhere((r) => r.id == id);
  }

  static final List<Restaurant> _mockRestaurants = [
    Restaurant(
      id: '1',
      name: 'Pizza Palace',
      image: '🍕',
      rating: 4.5,
      deliveryTime: 30,
      deliveryFee: 49,
      menu: [
        const MenuItem(id: '1', name: 'Margherita Pizza', description: 'Classic tomato and mozzarella', price: 299, image: '🍕'),
        const MenuItem(id: '2', name: 'Pepperoni Pizza', description: 'Pepperoni with cheese', price: 349, image: '🍕'),
        const MenuItem(id: '5', name: 'Coke', description: 'Refreshing cola drink', price: 59, image: '🥤'),
        const MenuItem(id: '6', name: 'Sprite', description: 'Lemon-lime soda', price: 59, image: '🥤'),
        const MenuItem(id: '7', name: 'French Fries', description: 'Crispy golden fries', price: 99, image: '🍟'),
      ],
    ),
    Restaurant(
      id: '2',
      name: 'Burger Barn',
      image: '🍔',
      rating: 4.2,
      deliveryTime: 25,
      deliveryFee: 39,
      menu: [
        const MenuItem(id: '3', name: 'Classic Burger', description: 'Beef patty with lettuce and tomato', price: 199, image: '🍔'),
        const MenuItem(id: '4', name: 'Cheese Burger', description: 'Classic burger with cheese', price: 229, image: '🍔'),
        const MenuItem(id: '8', name: 'Coke', description: 'Refreshing cola drink', price: 59, image: '🥤'),
        const MenuItem(id: '9', name: 'Orange Soda', description: 'Sweet orange flavored soda', price: 59, image: '🥤'),
        const MenuItem(id: '10', name: 'French Fries', description: 'Crispy golden fries', price: 99, image: '🍟'),
        const MenuItem(id: '11', name: 'Onion Rings', description: 'Crispy breaded onion rings', price: 119, image: '🧅'),
      ],
    ),
    Restaurant(
      id: '3',
      name: 'Taco Fiesta',
      image: '🌮',
      rating: 4.7,
      deliveryTime: 20,
      deliveryFee: 49,
      menu: [
        const MenuItem(id: '12', name: 'Beef Taco', description: 'Seasoned beef with lettuce and cheese', price: 79, image: '🌮'),
        const MenuItem(id: '13', name: 'Chicken Taco', description: 'Grilled chicken with salsa', price: 79, image: '🌮'),
        const MenuItem(id: '14', name: 'Burrito', description: 'Large flour tortilla with rice and beans', price: 179, image: '🌯'),
        const MenuItem(id: '15', name: 'Nachos', description: 'Tortilla chips with cheese and jalapeños', price: 139, image: '🧀'),
        const MenuItem(id: '16', name: 'Pepsi', description: 'Cola soft drink', price: 59, image: '🥤'),
      ],
    ),
    Restaurant(
      id: '4',
      name: 'Sushi Express',
      image: '🍣',
      rating: 4.8,
      deliveryTime: 35,
      deliveryFee: 79,
      menu: [
        const MenuItem(id: '17', name: 'California Roll', description: 'Crab, avocado, and cucumber', price: 179, image: '🍣'),
        const MenuItem(id: '18', name: 'Salmon Nigiri', description: 'Fresh salmon over rice', price: 99, image: '🍣'),
        const MenuItem(id: '19', name: 'Chicken Teriyaki', description: 'Grilled chicken with teriyaki sauce', price: 259, image: '🍗'),
        const MenuItem(id: '20', name: 'Miso Soup', description: 'Traditional Japanese soup', price: 79, image: '🍲'),
        const MenuItem(id: '21', name: 'Green Tea', description: 'Hot Japanese green tea', price: 49, image: '🍵'),
      ],
    ),
    Restaurant(
      id: '5',
      name: 'Pasta Corner',
      image: '🍝',
      rating: 4.3,
      deliveryTime: 28,
      deliveryFee: 59,
      menu: [
        const MenuItem(id: '22', name: 'Spaghetti Carbonara', description: 'Creamy pasta with bacon', price: 279, image: '🍝'),
        const MenuItem(id: '23', name: 'Fettuccine Alfredo', description: 'Rich and creamy white sauce', price: 259, image: '🍝'),
        const MenuItem(id: '24', name: 'Lasagna', description: 'Layered pasta with meat and cheese', price: 319, image: '🍝'),
        const MenuItem(id: '25', name: 'Caesar Salad', description: 'Romaine lettuce with parmesan', price: 159, image: '🥗'),
        const MenuItem(id: '26', name: 'Garlic Bread', description: 'Toasted bread with garlic butter', price: 99, image: '🍞'),
        const MenuItem(id: '27', name: 'Italian Soda', description: 'Sparkling flavored water', price: 59, image: '🥤'),
      ],
    ),
  ];
}