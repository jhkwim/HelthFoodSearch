import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_food_search/core/error/failures.dart';
import 'package:health_food_search/features/favorite/domain/entities/favorite_item.dart';
import 'package:health_food_search/features/favorite/domain/usecases/check_favorite_usecase.dart';
import 'package:health_food_search/features/favorite/domain/usecases/get_favorites_usecase.dart';
import 'package:health_food_search/features/favorite/domain/usecases/toggle_favorite_usecase.dart';
import 'package:health_food_search/features/favorite/presentation/bloc/favorite_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetFavoritesUseCase extends Mock implements GetFavoritesUseCase {}

class MockToggleFavoriteUseCase extends Mock implements ToggleFavoriteUseCase {}

class MockCheckFavoriteUseCase extends Mock implements CheckFavoriteUseCase {}

void main() {
  late FavoriteCubit cubit;
  late MockGetFavoritesUseCase mockGetFavorites;
  late MockToggleFavoriteUseCase mockToggleFavorite;
  late MockCheckFavoriteUseCase mockCheckFavorite;

  setUp(() {
    mockGetFavorites = MockGetFavoritesUseCase();
    mockToggleFavorite = MockToggleFavoriteUseCase();
    mockCheckFavorite = MockCheckFavoriteUseCase();
    cubit = FavoriteCubit(
      mockGetFavorites,
      mockToggleFavorite,
      mockCheckFavorite,
    );
  });

  tearDown(() {
    cubit.close();
  });

  final tFavorites = [
    FavoriteItem(
      reportNo: '12345',
      prdlstNm: '비타민C',
      addedAt: DateTime(2024, 1, 1),
    ),
    FavoriteItem(
      reportNo: '67890',
      prdlstNm: '오메가3',
      addedAt: DateTime(2024, 1, 2),
    ),
  ];

  group('FavoriteCubit', () {
    test('초기 상태는 FavoriteStatus.initial이어야 함', () {
      expect(cubit.state.status, FavoriteStatus.initial);
      expect(cubit.state.favorites, isEmpty);
      expect(cubit.state.favoriteReportNos, isEmpty);
    });

    group('loadFavorites', () {
      blocTest<FavoriteCubit, FavoriteState>(
        '즐겨찾기 로드 성공 시 favorites와 favoriteReportNos 업데이트',
        build: () {
          when(
            () => mockGetFavorites(),
          ).thenAnswer((_) async => Right(tFavorites));
          return cubit;
        },
        act: (cubit) => cubit.loadFavorites(),
        expect: () => [
          isA<FavoriteState>().having(
            (s) => s.status,
            'status',
            FavoriteStatus.loading,
          ),
          isA<FavoriteState>()
              .having((s) => s.status, 'status', FavoriteStatus.loaded)
              .having((s) => s.favorites.length, 'favorites count', 2)
              .having((s) => s.favoriteReportNos, 'reportNos', {
                '12345',
                '67890',
              }),
        ],
      );

      blocTest<FavoriteCubit, FavoriteState>(
        '즐겨찾기 로드 실패 시 error 상태',
        build: () {
          when(
            () => mockGetFavorites(),
          ).thenAnswer((_) async => const Left(CacheFailure('DB 오류')));
          return cubit;
        },
        act: (cubit) => cubit.loadFavorites(),
        expect: () => [
          isA<FavoriteState>().having(
            (s) => s.status,
            'status',
            FavoriteStatus.loading,
          ),
          isA<FavoriteState>()
              .having((s) => s.status, 'status', FavoriteStatus.error)
              .having((s) => s.failure, 'error', isNotNull),
        ],
      );
    });

    group('toggleFavorite', () {
      blocTest<FavoriteCubit, FavoriteState>(
        '즐겨찾기 추가 시 favoriteReportNos에 reportNo 추가',
        build: () {
          when(
            () => mockToggleFavorite(
              reportNo: any(named: 'reportNo'),
              prdlstNm: any(named: 'prdlstNm'),
            ),
          ).thenAnswer((_) async => const Right(true));
          when(
            () => mockGetFavorites(),
          ).thenAnswer((_) async => Right(tFavorites));
          return cubit;
        },
        act: (cubit) =>
            cubit.toggleFavorite(reportNo: '99999', prdlstNm: '테스트 제품'),
        verify: (_) {
          verify(
            () => mockToggleFavorite(reportNo: '99999', prdlstNm: '테스트 제품'),
          ).called(1);
        },
      );

      blocTest<FavoriteCubit, FavoriteState>(
        '즐겨찾기 해제 시 favoriteReportNos에서 reportNo 제거',
        seed: () => FavoriteState(
          status: FavoriteStatus.loaded,
          favorites: tFavorites,
          favoriteReportNos: const {'12345', '67890'},
        ),
        build: () {
          when(
            () => mockToggleFavorite(
              reportNo: any(named: 'reportNo'),
              prdlstNm: any(named: 'prdlstNm'),
            ),
          ).thenAnswer((_) async => const Right(false));
          when(() => mockGetFavorites()).thenAnswer(
            (_) async => Right([tFavorites[1]]), // 12345 제거됨
          );
          return cubit;
        },
        act: (cubit) =>
            cubit.toggleFavorite(reportNo: '12345', prdlstNm: '비타민C'),
        expect: () => [
          // 즉시 Set 업데이트
          isA<FavoriteState>().having(
            (s) => s.favoriteReportNos.contains('12345'),
            'removed from set',
            false,
          ),
          // loadFavorites 호출로 인한 loading
          isA<FavoriteState>().having(
            (s) => s.status,
            'status',
            FavoriteStatus.loading,
          ),
          // 최종 loaded
          isA<FavoriteState>().having((s) => s.favorites.length, 'count', 1),
        ],
      );
    });

    group('isFavorite', () {
      test('favoriteReportNos에 있는 reportNo는 true 반환', () {
        final state = FavoriteState(
          status: FavoriteStatus.loaded,
          favorites: tFavorites,
          favoriteReportNos: const {'12345', '67890'},
        );
        expect(state.isFavorite('12345'), true);
        expect(state.isFavorite('67890'), true);
      });

      test('favoriteReportNos에 없는 reportNo는 false 반환', () {
        final state = FavoriteState(
          status: FavoriteStatus.loaded,
          favorites: tFavorites,
          favoriteReportNos: const {'12345', '67890'},
        );
        expect(state.isFavorite('99999'), false);
      });
    });
  });
}
