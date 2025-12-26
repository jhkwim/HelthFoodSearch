import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_food_search/features/setting/domain/repositories/i_settings_repository.dart';
import 'package:health_food_search/features/setting/domain/usecases/fetch_and_apply_remote_rules_usecase.dart';
import 'package:health_food_search/core/config/remote_config_service.dart';
import 'package:health_food_search/core/utils/ingredient_refiner.dart';

class MockRemoteConfigService extends Mock implements RemoteConfigService {}

class MockSettingsRepository extends Mock implements ISettingsRepository {}

void main() {
  late FetchAndApplyRemoteRulesUseCase useCase;
  late MockRemoteConfigService mockRemoteConfigService;
  late MockSettingsRepository mockSettingsRepository;

  setUp(() {
    mockRemoteConfigService = MockRemoteConfigService();
    mockSettingsRepository = MockSettingsRepository();
    useCase = FetchAndApplyRemoteRulesUseCase(
      mockRemoteConfigService,
      mockSettingsRepository,
    );
  });

  test(
    'should load cached rules first, then fetch remote rules and save them',
    () async {
      // Arrange
      final cachedRules = {'TestRaw': 'TestRefined'};
      final remoteRules = {'NewRaw': 'NewRefined'};

      when(
        () => mockSettingsRepository.getRefinementRules(),
      ).thenAnswer((_) async => Right(cachedRules));

      when(
        () => mockRemoteConfigService.fetchRefinementRules(),
      ).thenAnswer((_) async => remoteRules);

      when(
        () => mockSettingsRepository.saveRefinementRules(any()),
      ).thenAnswer((_) async => const Right(null));

      // Act
      await useCase.execute();

      // Assert
      // 1. Verify cached rules loaded
      verify(() => mockSettingsRepository.getRefinementRules()).called(1);

      // 2. Verify remote fetched
      verify(() => mockRemoteConfigService.fetchRefinementRules()).called(1);

      // 3. Verify remote saved
      verify(
        () => mockSettingsRepository.saveRefinementRules(remoteRules),
      ).called(1);

      // 4. Verify Refiner updated
      // Since remote rules overwrite cached rules fully (source of truth),
      // 'TestRaw' from cache is no longer refining if not in remote.
      // We check if 'NewRaw' from remote is working.

      expect(IngredientRefiner.refine('NewRaw'), 'NewRefined');
    },
  );
}
