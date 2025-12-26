import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/i_favorite_repository.dart';

@injectable
class CheckFavoriteUseCase {
  final IFavoriteRepository repository;

  CheckFavoriteUseCase(this.repository);

  Future<Either<Failure, bool>> call(String reportNo) {
    return repository.isFavorite(reportNo);
  }
}
