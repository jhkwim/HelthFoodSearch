import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_food_search/core/enums/ingredient_search_type.dart';
import 'package:health_food_search/features/search/domain/entities/food_item.dart';
import 'package:health_food_search/features/search/domain/usecases/get_suggested_ingredients_usecase.dart';
import 'package:health_food_search/features/search/domain/usecases/search_food_by_ingredients_usecase.dart';
import 'package:health_food_search/features/search/presentation/bloc/ingredient_search_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchFoodByIngredientsUseCase extends Mock implements SearchFoodByIngredientsUseCase {}
class MockGetSuggestedIngredientsUseCase extends Mock implements GetSuggestedIngredientsUseCase {}

void main() {
  late IngredientSearchCubit cubit;
  late MockSearchFoodByIngredientsUseCase mockSearchUseCase;
  late MockGetSuggestedIngredientsUseCase mockSuggestUseCase;

  setUp(() {
    mockSearchUseCase = MockSearchFoodByIngredientsUseCase();
    mockSuggestUseCase = MockGetSuggestedIngredientsUseCase();
    cubit = IngredientSearchCubit(mockSearchUseCase, mockSuggestUseCase);
    
    // Register fallback values if needed for Any()
    registerFallbackValue(const SearchFoodByIngredientsParams(ingredients: [], type: IngredientSearchType.include));
    registerFallbackValue(IngredientSearchType.include);
  });

  tearDown(() {
    cubit.close();
  });

  group('IngredientSearchCubit', () {
    test('initial state is correct', () {
      expect(cubit.state, const IngredientSearchState());
    });

    group('addIngredient', () {
      blocTest<IngredientSearchCubit, IngredientSearchState>(
        'adds ingredient and triggers search',
        build: () {
          when(() => mockSearchUseCase(any())).thenAnswer((_) async => const Right([]));
          return cubit;
        },
        act: (cubit) => cubit.addIngredient('Vitamin C'),
        expect: () => [
          const IngredientSearchState(selectedIngredients: ['Vitamin C']),
          const IngredientSearchState(selectedIngredients: ['Vitamin C'], status: IngredientSearchStatus.loading),
          const IngredientSearchState(selectedIngredients: ['Vitamin C'], status: IngredientSearchStatus.loaded, searchResults: []),
        ],
        verify: (_) {
          verify(() => mockSearchUseCase(any())).called(1);
        },
      );

      blocTest<IngredientSearchCubit, IngredientSearchState>(
        'does not add duplicate ingredient',
        build: () => cubit,
        seed: () => const IngredientSearchState(selectedIngredients: ['Vitamin C']),
        act: (cubit) => cubit.addIngredient('Vitamin C'),
        expect: () => [], // No state change expected
      );
      
      blocTest<IngredientSearchCubit, IngredientSearchState>(
        'does not add empty ingredient',
        build: () => cubit,
        act: (cubit) => cubit.addIngredient('   '),
        expect: () => [],
      );
    });

    group('removeIngredient', () {
      blocTest<IngredientSearchCubit, IngredientSearchState>(
        'removes ingredient and triggers search',
        build: () {
           when(() => mockSearchUseCase(any())).thenAnswer((_) async => const Right([]));
           return cubit;
        },
        seed: () => const IngredientSearchState(selectedIngredients: ['A', 'B']),
        act: (cubit) => cubit.removeIngredient('A'),
        expect: () => [
          const IngredientSearchState(selectedIngredients: ['B']),
           const IngredientSearchState(selectedIngredients: ['B'], status: IngredientSearchStatus.loading),
          const IngredientSearchState(selectedIngredients: ['B'], status: IngredientSearchStatus.loaded, searchResults: []),
        ],
      );
    });
    
     group('search', () {
      final tFoodItems = [
        const FoodItem(
          reportNo: '1',
          prdlstNm: 'Test Food',
          mainIngredients: ['A'],
          functionality: 'Good',
          company: 'Test Co',
          guaranteePeriod: '2025',
          features: '',
          dispos: '',
          servingSize: '',
          cautions: '',
          standard: '',
        )
      ];

      blocTest<IngredientSearchCubit, IngredientSearchState>(
        'emits loaded with results when search is successful',
        build: () {
          when(() => mockSearchUseCase(any())).thenAnswer((_) async => Right(tFoodItems));
          return cubit;
        },
        seed: () => const IngredientSearchState(selectedIngredients: ['A']),
        act: (cubit) => cubit.search(),
        expect: () => [
          const IngredientSearchState(selectedIngredients: ['A'], status: IngredientSearchStatus.loading),
           IngredientSearchState(selectedIngredients: ['A'], status: IngredientSearchStatus.loaded, searchResults: tFoodItems),
        ],
      );
    });
  });
}
