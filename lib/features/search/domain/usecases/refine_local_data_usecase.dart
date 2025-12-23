import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:health_food_search/core/error/failures.dart';
import 'package:health_food_search/core/utils/ingredient_refiner.dart';
import 'package:health_food_search/features/search/data/models/food_item_hive_model.dart';
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
