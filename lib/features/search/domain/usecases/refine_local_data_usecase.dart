import 'dart:async';
import 'package:health_food_search/features/search/domain/repositories/i_food_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class RefineLocalDataUseCase {
  final IFoodRepository repository;

  RefineLocalDataUseCase(this.repository);

  Stream<double> call() {
    // Forward the stream from repository
    return repository.refineLocalData();
  }
}
