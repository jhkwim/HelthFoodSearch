import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_food_search/core/usecases/usecase.dart';
import 'package:health_food_search/features/setting/domain/entities/app_settings.dart';
import 'package:health_food_search/features/setting/domain/repositories/i_settings_repository.dart';
import 'package:health_food_search/features/setting/domain/usecases/check_update_needed_usecase.dart';

class MockISettingsRepository extends Mock implements ISettingsRepository {}

void main() {
  late CheckUpdateNeededUseCase useCase;
  late MockISettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockISettingsRepository();
    useCase = CheckUpdateNeededUseCase(mockRepository);
  });

  group('CheckUpdateNeededUseCase', () {
    test('should return true when lastSyncTime is null (never synced)', () async {
      // Arrange
      when(() => mockRepository.getSettings()).thenAnswer((_) async => 
        const Right(AppSettings(updateIntervalDays: 30, lastSyncTime: null))
      );

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result, const Right(true));
    });

    test('should return false when lastSyncTime is within interval (e.g., 10 days ago, interval 30)', () async {
      // Arrange
      final tenDaysAgo = DateTime.now().subtract(const Duration(days: 10));
      when(() => mockRepository.getSettings()).thenAnswer((_) async => 
        Right(AppSettings(updateIntervalDays: 30, lastSyncTime: tenDaysAgo))
      );

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result, const Right(false));
    });

    test('should return true when lastSyncTime is past interval (e.g., 31 days ago, interval 30)', () async {
      // Arrange
      final thirtyOneDaysAgo = DateTime.now().subtract(const Duration(days: 31));
      when(() => mockRepository.getSettings()).thenAnswer((_) async => 
        Right(AppSettings(updateIntervalDays: 30, lastSyncTime: thirtyOneDaysAgo))
      );

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result, const Right(true));
    });

    test('should respect configurable interval (e.g., 20 days ago, interval 15 -> true)', () async {
      // Arrange
      final twentyDaysAgo = DateTime.now().subtract(const Duration(days: 20));
      // User changed interval to 15 days
      when(() => mockRepository.getSettings()).thenAnswer((_) async => 
        Right(AppSettings(updateIntervalDays: 15, lastSyncTime: twentyDaysAgo))
      );

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result, const Right(true));
    });
    
    test('should respect configurable interval (e.g., 20 days ago, interval 60 -> false)', () async {
      // Arrange
      final twentyDaysAgo = DateTime.now().subtract(const Duration(days: 20));
      // User changed interval to 60 days
      when(() => mockRepository.getSettings()).thenAnswer((_) async => 
        Right(AppSettings(updateIntervalDays: 60, lastSyncTime: twentyDaysAgo))
      );

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result, const Right(false));
    });
  });
}
