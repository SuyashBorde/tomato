import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tomato/blocs/restaurant_bloc.dart';
import 'package:tomato/models/restaurant.dart';
import 'package:tomato/repositories/restaurant_repository.dart';

class MockRestaurantRepository extends Mock implements RestaurantRepository {}

void main() {
  group('RestaurantBloc', () {
    late RestaurantBloc restaurantBloc;
    late MockRestaurantRepository mockRepository;
    late List<Restaurant> testRestaurants;

    setUp(() {
      mockRepository = MockRestaurantRepository();
      restaurantBloc = RestaurantBloc(mockRepository);
      testRestaurants = [
        Restaurant(
          id: '1',
          name: 'Test Restaurant',
          image: '🍕',
          rating: 4.5,
          deliveryTime: 30,
          deliveryFee: 2.99,
          menu: const [],
        ),
      ];
    });

    tearDown(() {
      restaurantBloc.close();
    });

    test('initial state is RestaurantInitial', () {
      expect(restaurantBloc.state, RestaurantInitial());
    });

    blocTest<RestaurantBloc, RestaurantState>(
      'emits [RestaurantLoading, RestaurantLoaded] when LoadRestaurants succeeds',
      build: () {
        when(() => mockRepository.getRestaurants())
            .thenAnswer((_) async => testRestaurants);
        return restaurantBloc;
      },
      act: (bloc) => bloc.add(LoadRestaurants()),
      expect: () => [
        RestaurantLoading(),
        RestaurantLoaded(testRestaurants),
      ],
    );

    blocTest<RestaurantBloc, RestaurantState>(
      'emits [RestaurantLoading, RestaurantError] when LoadRestaurants fails',
      build: () {
        when(() => mockRepository.getRestaurants())
            .thenThrow(Exception('Network error'));
        return restaurantBloc;
      },
      act: (bloc) => bloc.add(LoadRestaurants()),
      expect: () => [
        RestaurantLoading(),
        RestaurantError('Exception: Network error'),
      ],
    );

    blocTest<RestaurantBloc, RestaurantState>(
      'emits [RestaurantLoading, RestaurantSelected] when SelectRestaurant succeeds',
      build: () {
        when(() => mockRepository.getRestaurant('1'))
            .thenAnswer((_) async => testRestaurants.first);
        return restaurantBloc;
      },
      act: (bloc) => bloc.add(SelectRestaurant('1')),
      expect: () => [
        RestaurantLoading(),
        RestaurantSelected(testRestaurants.first),
      ],
    );
  });
}