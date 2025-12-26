import 'package:injectable/injectable.dart';
import '../../../../core/config/remote_config_service.dart';
import '../../../../core/utils/ingredient_refiner.dart';
import '../repositories/i_settings_repository.dart';

@lazySingleton
class FetchAndApplyRemoteRulesUseCase {
  final RemoteConfigService _remoteConfigService;
  final ISettingsRepository _settingsRepository;

  FetchAndApplyRemoteRulesUseCase(
    this._remoteConfigService,
    this._settingsRepository,
  );

  /// 1. Load cached rules -> Apply
  /// 2. Fetch remote rules -> Apply -> Store
  Future<bool> execute() async {
    // 1. Load cached rules first (Fast)
    final cachedResult = await _settingsRepository.getRefinementRules();
    cachedResult.fold(
      (failure) => null, // Ignore failure
      (rules) {
        if (rules.isNotEmpty) {
          IngredientRefiner.updateRules(rules);
        }
      },
    );

    // 2. Fetch remote rules (Async)
    try {
      final remoteRules = await _remoteConfigService.fetchRefinementRules();
      if (remoteRules.isNotEmpty) {
        // Apply immediately
        IngredientRefiner.updateRules(remoteRules);

        // Save to cache
        await _settingsRepository.saveRefinementRules(remoteRules);
        return true;
      }
    } catch (e) {
      // Log or ignore network errors silently
      print('Failed to sync remote rules: $e');
    }
    return false;
  }
}
