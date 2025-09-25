import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tomato/blocs/cart_bloc.dart';
import 'package:tomato/models/cart.dart';
import 'package:tomato/models/restaurant.dart';

void main() {
  group('CartBloc', () {
    late CartBloc cartBloc;
    late Restaurant testRestaurant;
    late MenuItem testMenuItem;

    setUp(() {
      cartBloc = CartBloc();
      testMenuItem = const MenuItem(
        id: '1',
        name: 'Test Pizza',
        description: 'Test description',
        price: 10.99,
        image: '🍕',
      );
      testRestaurant = Restaurant(
        id: '1',
        name: 'Test Restaurant',
        image: '🍕',
        rating: 4.5,
        deliveryTime: 30,
        deliveryFee: 2.99,
        menu: [testMenuItem],
      );
    });

    tearDown(() {
      cartBloc.close();
    });

    test('initial state is empty cart', () {
      expect(cartBloc.state.cart.items, isEmpty);
      expect(cartBloc.state.cart.total, 0);
    });

    blocTest<CartBloc, CartState>(
      'emits updated cart when item is added',
      build: () => cartBloc,
      act: (bloc) => bloc.add(AddToCart(testMenuItem, testRestaurant)),
      expect: () => [
        CartState(Cart(
          items: [CartItem(menuItem: testMenuItem, quantity: 1)],
          restaurant: testRestaurant,
        )),
      ],
    );

    blocTest<CartBloc, CartState>(
      'increases quantity when same item is added twice',
      build: () => cartBloc,
      act: (bloc) {
        bloc.add(AddToCart(testMenuItem, testRestaurant));
        bloc.add(AddToCart(testMenuItem, testRestaurant));
      },
      expect: () => [
        CartState(Cart(
          items: [CartItem(menuItem: testMenuItem, quantity: 1)],
          restaurant: testRestaurant,
        )),
        CartState(Cart(
          items: [CartItem(menuItem: testMenuItem, quantity: 2)],
          restaurant: testRestaurant,
        )),
      ],
    );

    blocTest<CartBloc, CartState>(
      'removes item from cart',
      build: () => cartBloc,
      seed: () => CartState(Cart(
        items: [CartItem(menuItem: testMenuItem, quantity: 1)],
        restaurant: testRestaurant,
      )),
      act: (bloc) => bloc.add(RemoveFromCart(testMenuItem)),
      expect: () => [
        CartState(Cart(items: const [], restaurant: testRestaurant)),
      ],
    );

    blocTest<CartBloc, CartState>(
      'clears entire cart',
      build: () => cartBloc,
      seed: () => CartState(Cart(
        items: [CartItem(menuItem: testMenuItem, quantity: 2)],
        restaurant: testRestaurant,
      )),
      act: (bloc) => bloc.add(ClearCart()),
      expect: () => [
        CartState(const Cart()),
      ],
    );
  });
}