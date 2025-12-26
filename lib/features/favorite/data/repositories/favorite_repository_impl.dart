import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/favorite_item.dart';
import '../../domain/entities/search_history.dart';
import '../../domain/repositories/i_favorite_repository.dart';
import '../models/favorite_hive_model.dart';
import '../models/search_history_hive_model.dart';

@LazySingleton(as: IFavoriteRepository)
class FavoriteRepositoryImpl implements IFavoriteRepository {
  static const String favoritesBoxName = 'favorites';
  static const String historyBoxName = 'search_history';
  static const int maxHistoryItems = 20;

  // 즐겨찾기
  @override
  Future<Either<Failure, List<FavoriteItem>>> getFavorites() async {
    try {
      final box = await Hive.openBox<FavoriteHiveModel>(favoritesBoxName);
      final items = box.values
          .map(
            (m) => FavoriteItem(
              reportNo: m.reportNo,
              prdlstNm: m.prdlstNm,
              addedAt: m.addedAt,
            ),
          )
          .toList();
      items.sort((a, b) => b.addedAt.compareTo(a.addedAt)); // 최신순
      return Right(items);
    } catch (e) {
      debugPrint('getFavorites error: $e');
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addFavorite(FavoriteItem item) async {
    try {
      final box = await Hive.openBox<FavoriteHiveModel>(favoritesBoxName);
      await box.put(
        item.reportNo,
        FavoriteHiveModel(
          reportNo: item.reportNo,
          prdlstNm: item.prdlstNm,
          addedAt: item.addedAt,
        ),
      );
      return const Right(null);
    } catch (e) {
      debugPrint('addFavorite error: $e');
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(String reportNo) async {
    try {
      final box = await Hive.openBox<FavoriteHiveModel>(favoritesBoxName);
      await box.delete(reportNo);
      return const Right(null);
    } catch (e) {
      debugPrint('removeFavorite error: $e');
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(String reportNo) async {
    try {
      final box = await Hive.openBox<FavoriteHiveModel>(favoritesBoxName);
      return Right(box.containsKey(reportNo));
    } catch (e) {
      debugPrint('isFavorite error: $e');
      return Left(CacheFailure(e.toString()));
    }
  }

  // 검색 히스토리
  @override
  Future<Either<Failure, List<SearchHistory>>> getSearchHistory() async {
    try {
      final box = await Hive.openBox<SearchHistoryHiveModel>(historyBoxName);
      final items = box.values
          .map(
            (m) => SearchHistory(
              query: m.query,
              type: m.type,
              searchedAt: m.searchedAt,
            ),
          )
          .toList();
      items.sort((a, b) => b.searchedAt.compareTo(a.searchedAt)); // 최신순
      return Right(items.take(maxHistoryItems).toList());
    } catch (e) {
      debugPrint('getSearchHistory error: $e');
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addSearchHistory(SearchHistory history) async {
    try {
      final box = await Hive.openBox<SearchHistoryHiveModel>(historyBoxName);

      // 중복 제거 (같은 query+type이면 삭제 후 재추가)
      final existingKey = box.keys.cast<int?>().firstWhere((key) {
        if (key == null) return false;
        final item = box.get(key);
        return item?.query == history.query && item?.type == history.type;
      }, orElse: () => null);
      if (existingKey != null) {
        await box.delete(existingKey);
      }

      await box.add(
        SearchHistoryHiveModel(
          query: history.query,
          type: history.type,
          searchedAt: history.searchedAt,
        ),
      );

      // 최대 개수 초과 시 오래된 항목 삭제
      if (box.length > maxHistoryItems) {
        final keysToDelete = box.keys.take(box.length - maxHistoryItems);
        await box.deleteAll(keysToDelete);
      }

      return const Right(null);
    } catch (e) {
      debugPrint('addSearchHistory error: $e');
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearSearchHistory() async {
    try {
      final box = await Hive.openBox<SearchHistoryHiveModel>(historyBoxName);
      await box.clear();
      return const Right(null);
    } catch (e) {
      debugPrint('clearSearchHistory error: $e');
      return Left(CacheFailure(e.toString()));
    }
  }
}
