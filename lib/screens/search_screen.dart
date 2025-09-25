import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/restaurant_bloc.dart';
import '../models/restaurant.dart';
import 'restaurant_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  double _minRating = 0;
  double _maxDeliveryTime = 60;
  double _maxDeliveryFee = 100;
  String _sortBy = 'rating';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search restaurants or menu items...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
                const SizedBox(height: 16),
                ExpansionTile(
                  title: const Text('Filters'),
                  children: [
                    ListTile(
                      title: Text('Min Rating: ${_minRating.toStringAsFixed(1)}'),
                      subtitle: Slider(
                        value: _minRating,
                        min: 0,
                        max: 5,
                        divisions: 10,
                        onChanged: (value) {
                          setState(() {
                            _minRating = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text('Max Delivery Time: ${_maxDeliveryTime.toInt()} min'),
                      subtitle: Slider(
                        value: _maxDeliveryTime,
                        min: 10,
                        max: 60,
                        divisions: 10,
                        onChanged: (value) {
                          setState(() {
                            _maxDeliveryTime = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text('Max Delivery Fee: ₹${_maxDeliveryFee.toInt()}'),
                      subtitle: Slider(
                        value: _maxDeliveryFee,
                        min: 0,
                        max: 100,
                        divisions: 10,
                        onChanged: (value) {
                          setState(() {
                            _maxDeliveryFee = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Sort By'),
                      subtitle: DropdownButton<String>(
                        value: _sortBy,
                        items: const [
                          DropdownMenuItem(value: 'rating', child: Text('Rating')),
                          DropdownMenuItem(value: 'deliveryTime', child: Text('Delivery Time')),
                          DropdownMenuItem(value: 'deliveryFee', child: Text('Delivery Fee')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _sortBy = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<RestaurantBloc, RestaurantState>(
              builder: (context, state) {
                if (state is RestaurantLoaded) {
                  final filteredResults = _getFilteredResults(state.restaurants);
                  
                  if (filteredResults.isEmpty) {
                    return const Center(child: Text('No results found'));
                  }
                  
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredResults.length,
                    itemBuilder: (context, index) {
                      final result = filteredResults[index];
                      if (result['type'] == 'restaurant') {
                        return _RestaurantCard(restaurant: result['data']);
                      } else {
                        return _MenuItemCard(
                          menuItem: result['data'],
                          restaurant: result['restaurant'],
                        );
                      }
                    },
                  );
                }
                return const Center(child: Text('Start searching...'));
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredResults(List<Restaurant> restaurants) {
    List<Map<String, dynamic>> results = [];
    
    // Filter restaurants
    final filteredRestaurants = restaurants.where((restaurant) {
      return restaurant.rating >= _minRating &&
             restaurant.deliveryTime <= _maxDeliveryTime &&
             restaurant.deliveryFee <= _maxDeliveryFee &&
             (_searchQuery.isEmpty || restaurant.name.toLowerCase().contains(_searchQuery));
    }).toList();
    
    // Sort restaurants
    filteredRestaurants.sort((a, b) {
      switch (_sortBy) {
        case 'rating':
          return b.rating.compareTo(a.rating);
        case 'deliveryTime':
          return a.deliveryTime.compareTo(b.deliveryTime);
        case 'deliveryFee':
          return a.deliveryFee.compareTo(b.deliveryFee);
        default:
          return 0;
      }
    });
    
    // Add restaurants to results
    for (final restaurant in filteredRestaurants) {
      results.add({'type': 'restaurant', 'data': restaurant});
    }
    
    // Search menu items if query is not empty
    if (_searchQuery.isNotEmpty) {
      for (final restaurant in restaurants) {
        for (final menuItem in restaurant.menu) {
          if (menuItem.name.toLowerCase().contains(_searchQuery) ||
              menuItem.description.toLowerCase().contains(_searchQuery)) {
            results.add({
              'type': 'menuItem',
              'data': menuItem,
              'restaurant': restaurant,
            });
          }
        }
      }
    }
    
    return results;
  }
}

class _RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const _RestaurantCard({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RestaurantDetailScreen(restaurant: restaurant),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(restaurant.image, style: const TextStyle(fontSize: 40)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(restaurant.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('⭐ ${restaurant.rating} • ${restaurant.deliveryTime} min • ₹${restaurant.deliveryFee.toStringAsFixed(0)}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final MenuItem menuItem;
  final Restaurant restaurant;

  const _MenuItemCard({required this.menuItem, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RestaurantDetailScreen(restaurant: restaurant),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(menuItem.image, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(menuItem.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(menuItem.description, style: const TextStyle(color: Colors.grey)),
                    Text('₹${menuItem.price.toStringAsFixed(0)} • from ${restaurant.name}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}