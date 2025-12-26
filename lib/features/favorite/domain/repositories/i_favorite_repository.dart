import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/favorite_item.dart';
import '../entities/search_history.dart';

/// 즐겨찾기 및 검색 히스토리 Repository 인터페이스
abstract class IFavoriteRepository {
  // 즐겨찾기
  Future<Either<Failure, List<FavoriteItem>>> getFavorites();
  Future<Either<Failure, void>> addFavorite(FavoriteItem item);
  Future<Either<Failure, void>> removeFavorite(String reportNo);
  Future<Either<Failure, bool>> isFavorite(String reportNo);

  // 검색 히스토리
  Future<Either<Failure, List<SearchHistory>>> getSearchHistory();
  Future<Either<Failure, void>> addSearchHistory(SearchHistory history);
  Future<Either<Failure, void>> clearSearchHistory();
}
