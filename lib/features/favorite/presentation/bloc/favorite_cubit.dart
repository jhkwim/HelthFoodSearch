import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/favorite_item.dart';
import '../../domain/usecases/get_favorites_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';
import '../../domain/usecases/check_favorite_usecase.dart';

part 'favorite_state.dart';

@lazySingleton // 앱 전체에서 하나의 인스턴스 공유
class FavoriteCubit extends Cubit<FavoriteState> {
  final GetFavoritesUseCase getFavoritesUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;
  final CheckFavoriteUseCase checkFavoriteUseCase;

  FavoriteCubit(
    this.getFavoritesUseCase,
    this.toggleFavoriteUseCase,
    this.checkFavoriteUseCase,
  ) : super(const FavoriteState());

  /// 즐겨찾기 목록 로드 (앱 시작 시 호출)
  Future<void> loadFavorites() async {
    emit(state.copyWith(status: FavoriteStatus.loading));
    final result = await getFavoritesUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FavoriteStatus.error,
          errorMessage: failure.userMessage,
        ),
      ),
      (favorites) {
        final reportNos = favorites.map((f) => f.reportNo).toSet();
        emit(
          state.copyWith(
            status: FavoriteStatus.loaded,
            favorites: favorites,
            favoriteReportNos: reportNos,
          ),
        );
      },
    );
  }

  /// 즐겨찾기 토글
  Future<void> toggleFavorite({
    required String reportNo,
    required String prdlstNm,
  }) async {
    final result = await toggleFavoriteUseCase(
      reportNo: reportNo,
      prdlstNm: prdlstNm,
    );
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.userMessage)),
      (isAdded) {
        // 즉시 Set 업데이트 (빠른 UI 반영)
        final newSet = Set<String>.from(state.favoriteReportNos);
        if (isAdded) {
          newSet.add(reportNo);
        } else {
          newSet.remove(reportNo);
        }
        emit(state.copyWith(favoriteReportNos: newSet));
        // 전체 목록 새로고침
        loadFavorites();
      },
    );
  }
}
