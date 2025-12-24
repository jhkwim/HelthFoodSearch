import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_settings_repository.dart';

@injectable
class SaveThemeModeUseCase implements UseCase<void, ThemeMode> {
  final ISettingsRepository repository;

  SaveThemeModeUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ThemeMode mode) {
    return repository.saveThemeMode(mode);
  }
}
