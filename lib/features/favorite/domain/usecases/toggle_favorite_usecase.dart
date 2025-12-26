import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/favorite_item.dart';
import '../repositories/i_favorite_repository.dart';

@injectable
class ToggleFavoriteUseCase {
  final IFavoriteRepository repository;

  ToggleFavoriteUseCase(this.repository);

  /// 즐겨찾기 토글 (있으면 삭제, 없으면 추가)
  /// Returns: true if added, false if removed
  Future<Either<Failure, bool>> call({
    required String reportNo,
    required String prdlstNm,
  }) async {
    final isFavResult = await repository.isFavorite(reportNo);
    return isFavResult.fold(Left.new, (isFav) async {
      if (isFav) {
        final removeResult = await repository.removeFavorite(reportNo);
        return removeResult.fold(Left.new, (_) => const Right(false));
      } else {
        final addResult = await repository.addFavorite(
          FavoriteItem(
            reportNo: reportNo,
            prdlstNm: prdlstNm,
            addedAt: DateTime.now(),
          ),
        );
        return addResult.fold(Left.new, (_) => const Right(true));
      }
    });
  }
}
