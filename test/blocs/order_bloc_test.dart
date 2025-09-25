import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tomato/blocs/order_bloc.dart';
import 'package:tomato/models/cart.dart';
import 'package:tomato/models/order.dart';
import 'package:tomato/models/restaurant.dart';
import 'package:tomato/repositories/order_repository.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

void main() {
  group('OrderBloc', () {
    late OrderBloc orderBloc;
    late MockOrderRepository mockRepository;
    late Cart testCart;
    late Order testOrder;

    setUp(() {
      mockRepository = MockOrderRepository();
      orderBloc = OrderBloc(mockRepository);
      
      testCart = Cart(
        items: [
          CartItem(
            menuItem: const MenuItem(
              id: '1',
              name: 'Test Pizza',
              description: 'Test',
              price: 10.99,
              image: '🍕',
            ),
            quantity: 1,
          ),
        ],
        restaurant: Restaurant(
          id: '1',
          name: 'Test Restaurant',
          image: '🍕',
          rating: 4.5,
          deliveryTime: 30,
          deliveryFee: 2.99,
          menu: const [],
        ),
      );
      
      testOrder = Order(
        id: '123',
        cart: testCart,
        status: OrderStatus.confirmed,
        createdAt: DateTime.now(),
      );
    });

    tearDown(() {
      orderBloc.close();
    });

    test('initial state is OrderInitial', () {
      expect(orderBloc.state, OrderInitial());
    });

    blocTest<OrderBloc, OrderState>(
      'emits [OrderPlacing, OrderPlaced] when PlaceOrder succeeds',
      build: () {
        when(() => mockRepository.placeOrder(testCart))
            .thenAnswer((_) async => testOrder);
        return orderBloc;
      },
      act: (bloc) => bloc.add(PlaceOrder(testCart)),
      expect: () => [
        OrderPlacing(),
        OrderPlaced(testOrder),
      ],
    );

    blocTest<OrderBloc, OrderState>(
      'emits [OrderPlacing, OrderError] when PlaceOrder fails',
      build: () {
        when(() => mockRepository.placeOrder(testCart))
            .thenThrow(Exception('Payment failed'));
        return orderBloc;
      },
      act: (bloc) => bloc.add(PlaceOrder(testCart)),
      expect: () => [
        OrderPlacing(),
        OrderError('Exception: Payment failed'),
      ],
    );

    blocTest<OrderBloc, OrderState>(
      'emits [OrderTracking] when TrackOrder succeeds',
      build: () {
        when(() => mockRepository.getOrderStatus('123'))
            .thenAnswer((_) async => testOrder);
        return orderBloc;
      },
      act: (bloc) => bloc.add(TrackOrder('123')),
      expect: () => [
        OrderTracking(testOrder),
      ],
    );
  });
}