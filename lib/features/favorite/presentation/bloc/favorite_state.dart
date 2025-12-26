part of 'favorite_cubit.dart';

enum FavoriteStatus { initial, loading, loaded, error }

class FavoriteState extends Equatable {
  final FavoriteStatus status;
  final List<FavoriteItem> favorites;
  final Set<String> favoriteReportNos; // 모든 즐겨찾기 reportNo 집합
  final String? errorMessage;

  const FavoriteState({
    this.status = FavoriteStatus.initial,
    this.favorites = const [],
    this.favoriteReportNos = const {},
    this.errorMessage,
  });

  /// 특정 reportNo가 즐겨찾기인지 확인
  bool isFavorite(String reportNo) => favoriteReportNos.contains(reportNo);

  FavoriteState copyWith({
    FavoriteStatus? status,
    List<FavoriteItem>? favorites,
    Set<String>? favoriteReportNos,
    String? errorMessage,
  }) {
    return FavoriteState(
      status: status ?? this.status,
      favorites: favorites ?? this.favorites,
      favoriteReportNos: favoriteReportNos ?? this.favoriteReportNos,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    favorites,
    favoriteReportNos,
    errorMessage,
  ];
}
