part of 'favorite_cubit.dart';

enum FavoriteStatus { initial, loading, loaded, error }

class FavoriteState extends Equatable {
  final FavoriteStatus status;
  final List<FavoriteItem> favorites;
  final Set<String> favoriteReportNos; // 모든 즐겨찾기 reportNo 집합
  final Failure? failure;

  const FavoriteState({
    this.status = FavoriteStatus.initial,
    this.favorites = const [],
    this.favoriteReportNos = const {},
    this.failure,
  });

  /// 특정 reportNo가 즐겨찾기인지 확인
  bool isFavorite(String reportNo) => favoriteReportNos.contains(reportNo);

  FavoriteState copyWith({
    FavoriteStatus? status,
    List<FavoriteItem>? favorites,
    Set<String>? favoriteReportNos,
    Failure? failure,
  }) {
    return FavoriteState(
      status: status ?? this.status,
      favorites: favorites ?? this.favorites,
      favoriteReportNos: favoriteReportNos ?? this.favoriteReportNos,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [status, favorites, favoriteReportNos, failure];
}
