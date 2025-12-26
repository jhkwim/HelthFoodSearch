import 'package:flutter/foundation.dart';
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
    Map<String, String> cachedRules = {};

    // 1. Load cached rules first (Fast)
    final cachedResult = await _settingsRepository.getRefinementRules();
    cachedResult.fold(
      (failure) => null, // Ignore failure
      (rules) {
        if (rules.isNotEmpty) {
          cachedRules = rules;
          IngredientRefiner.updateRules(rules);
        }
      },
    );

    // 2. Fetch remote rules (Async)
    try {
      final remoteRules = await _remoteConfigService.fetchRefinementRules();
      if (remoteRules.isNotEmpty) {
        // Check difference
        final hasChanged = !mapEquals(cachedRules, remoteRules);

        if (hasChanged) {
          // Apply & Save
          IngredientRefiner.updateRules(remoteRules);
          await _settingsRepository.saveRefinementRules(remoteRules);
          return true; // Rules Updated
        } else {
          // Even if same, we might want to update the timestamp
          // But repository.saveRefinementRules does that.
          // Let's just update timestamp if we want "checked at" semantics.
          // Current repo impl saves timestamp on saveRefinementRules.
          // If we don't save, timestamp remains old.
          // User wants "Time updated" -> "Checked time" or "Content Changed time"?
          // Use case 6: "Time only update".
          await _settingsRepository.saveRefinementRules(remoteRules);
          return false; // Content Same
        }
      }
    } catch (e) {
      // Log or ignore network errors silently
      print('Failed to sync remote rules: $e');
    }
    return false;
  }
}
