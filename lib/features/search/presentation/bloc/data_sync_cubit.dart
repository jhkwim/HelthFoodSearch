import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/check_data_existence_usecase.dart';
import '../../domain/usecases/sync_data_usecase.dart';
import '../../../setting/domain/usecases/get_settings_usecase.dart';
import '../../../setting/domain/usecases/check_update_needed_usecase.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/storage_info.dart';
import '../../domain/usecases/get_storage_info_usecase.dart';
import '../../../setting/domain/usecases/save_last_sync_time_usecase.dart';
import '../../../setting/domain/usecases/fetch_and_apply_remote_rules_usecase.dart';
import '../../domain/usecases/clear_data_usecase.dart';

part 'data_sync_state.dart';

@lazySingleton
class DataSyncCubit extends Cubit<DataSyncState> {
  final SyncDataUseCase syncDataUseCase;
  final CheckDataExistenceUseCase checkDataExistenceUseCase;
  final GetSettingsUseCase getSettingsUseCase;
  final GetStorageInfoUseCase getStorageInfoUseCase;
  final SaveLastSyncTimeUseCase saveLastSyncTimeUseCase;
  final CheckUpdateNeededUseCase checkUpdateNeededUseCase;
  final FetchAndApplyRemoteRulesUseCase fetchAndApplyRemoteRulesUseCase;
  final ClearDataUseCase clearDataUseCase;

  DataSyncCubit(
    this.syncDataUseCase,
    this.checkDataExistenceUseCase,
    this.getSettingsUseCase,
    this.getStorageInfoUseCase,
    this.saveLastSyncTimeUseCase,
    this.checkUpdateNeededUseCase,
    this.fetchAndApplyRemoteRulesUseCase,
    this.clearDataUseCase,
  ) : super(DataSyncInitial());

  Future<void> checkData() async {
    emit(DataSyncLoading());
    final result = await checkDataExistenceUseCase(NoParams());
    result.fold((failure) => emit(DataSyncError(failure.message)), (
      hasData,
    ) async {
      if (hasData) {
        final infoResult = await getStorageInfoUseCase(NoParams());
        final updateCheckResult = await checkUpdateNeededUseCase(NoParams());
        final bool updateNeeded = updateCheckResult.getOrElse(() => false);

        infoResult.fold(
          (l) =>
              emit(DataSyncSuccess(updateNeeded: updateNeeded)), // Ignore error
          (info) => emit(
            DataSyncSuccess(storageInfo: info, updateNeeded: updateNeeded),
          ),
        );
      } else {
        emit(DataSyncNeeded());
      }
    });
  }

  Future<void> syncData() async {
    // 1. Get API Key
    final settingsResult = await getSettingsUseCase(NoParams());
    String? apiKey;
    settingsResult.fold(
      (f) => emit(DataSyncError(f.message)),
      (s) => apiKey = s.apiKey,
    );

    if (apiKey == null || apiKey!.isEmpty) {
      emit(const DataSyncError('API Key not found'));
      return;
    }

    emit(const DataSyncInProgress(0.0));

    // 0. Fetch Remote Rules First
    // This ensures that when we download and parse data, we use the latest refinement rules.
    try {
      await fetchAndApplyRemoteRulesUseCase.execute();
    } catch (e) {
      // Proceed even if rule fetch fails (fallback to cached/hardcoded rules)
      debugPrint('Rule fetch during sync failed: $e');
    }

    final result = await syncDataUseCase(
      SyncDataParams(
        apiKey: apiKey!,
        onProgress: (progress) {
          emit(DataSyncInProgress(progress));
        },
      ),
    );

    result.fold((failure) => emit(DataSyncError(failure.message)), (_) async {
      // Save Last Sync Time
      await saveLastSyncTimeUseCase(DateTime.now());

      final infoResult = await getStorageInfoUseCase(NoParams());
      infoResult.fold(
        (l) => emit(const DataSyncSuccess()),
        (info) => emit(DataSyncSuccess(storageInfo: info)),
      );
    });
  }

  Future<void> clearData() async {
    emit(DataSyncLoading());
    final result = await clearDataUseCase(NoParams());
    result.fold(
      (failure) => emit(DataSyncError(failure.message)),
      (_) => emit(DataSyncNeeded()),
    );
  }
}
