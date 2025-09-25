import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/restaurant_bloc.dart';
import 'blocs/cart_bloc.dart';
import 'blocs/order_bloc.dart';
import 'blocs/history_bloc.dart';
import 'repositories/restaurant_repository.dart';
import 'repositories/order_repository.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  runApp(const TomatoApp());
}

class TomatoApp extends StatelessWidget {
  const TomatoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<RestaurantRepository>(
          create: (context) => MockRestaurantRepository(),
        ),
        RepositoryProvider<OrderRepository>(
          create: (context) => MockOrderRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (context) =>
                    RestaurantBloc(context.read<RestaurantRepository>())
                      ..add(LoadRestaurants()),
          ),
          BlocProvider(create: (context) => CartBloc()),
          BlocProvider(
            create: (context) => OrderBloc(context.read<OrderRepository>()),
          ),
          BlocProvider(create: (context) => HistoryBloc()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Tomato Food Delivery',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          ),
          home: const MainNavigationScreen(),
        ),
      ),
    );
  }
}
