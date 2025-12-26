import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/favorite_item.dart';
import '../repositories/i_favorite_repository.dart';

@injectable
class GetFavoritesUseCase {
  final IFavoriteRepository repository;

  GetFavoritesUseCase(this.repository);

  Future<Either<Failure, List<FavoriteItem>>> call() {
    return repository.getFavorites();
  }
}
