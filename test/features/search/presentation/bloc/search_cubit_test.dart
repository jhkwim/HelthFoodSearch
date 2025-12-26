import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_food_search/core/error/failures.dart';
import 'package:health_food_search/features/search/domain/entities/food_item.dart';
import 'package:health_food_search/features/search/domain/usecases/search_food_by_name_usecase.dart';
import 'package:health_food_search/features/search/presentation/bloc/search_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchFoodByNameUseCase extends Mock
    implements SearchFoodByNameUseCase {}

void main() {
  late SearchCubit cubit;
  late MockSearchFoodByNameUseCase mockSearchUseCase;

  setUp(() {
    mockSearchUseCase = MockSearchFoodByNameUseCase();
    cubit = SearchCubit(mockSearchUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('SearchCubit', () {
    const tQuery = '비타민';
    final List<FoodItem> tFoodItems = [
      const FoodItem(
        reportNo: '12345',
        prdlstNm: '비타민C 1000',
        rawmtrlNm: '비타민C',
        mainIngredients: ['비타민C'],
        bsshNm: '테스트업체',
        prmsDt: '20240101',
      ),
    ];

    test('초기 상태는 SearchInitial이어야 함', () {
      expect(cubit.state, isA<SearchInitial>());
    });

    blocTest<SearchCubit, SearchState>(
      '빈 쿼리로 검색 시 SearchInitial 상태 유지',
      build: () => cubit,
      act: (cubit) => cubit.search(''),
      expect: () => [isA<SearchInitial>()],
    );

    blocTest<SearchCubit, SearchState>(
      '검색 성공 시 SearchLoading → SearchLoaded 상태 전이',
      build: () {
        when(
          () => mockSearchUseCase(tQuery),
        ).thenAnswer((_) async => Right(tFoodItems));
        return cubit;
      },
      act: (cubit) => cubit.search(tQuery),
      expect: () => [
        isA<SearchLoading>(),
        isA<SearchLoaded>().having((s) => s.foods.length, 'foods length', 1),
      ],
      verify: (_) {
        verify(() => mockSearchUseCase(tQuery)).called(1);
      },
    );

    blocTest<SearchCubit, SearchState>(
      '검색 실패 시 SearchLoading → SearchError 상태 전이',
      build: () {
        when(
          () => mockSearchUseCase(tQuery),
        ).thenAnswer((_) async => const Left(CacheFailure('DB 오류')));
        return cubit;
      },
      act: (cubit) => cubit.search(tQuery),
      expect: () => [
        isA<SearchLoading>(),
        isA<SearchError>().having((s) => s.message, 'error message', 'DB 오류'),
      ],
    );

    blocTest<SearchCubit, SearchState>(
      '검색 결과가 없을 때 빈 리스트로 SearchLoaded 상태',
      build: () {
        when(
          () => mockSearchUseCase(tQuery),
        ).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (cubit) => cubit.search(tQuery),
      expect: () => [
        isA<SearchLoading>(),
        isA<SearchLoaded>().having(
          (s) => s.foods.isEmpty,
          'foods is empty',
          true,
        ),
      ],
    );
  });
}
