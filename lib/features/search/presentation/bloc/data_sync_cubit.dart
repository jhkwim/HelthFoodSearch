import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/check_data_existence_usecase.dart';
import '../../domain/usecases/sync_data_usecase.dart';
import '../../../setting/domain/usecases/get_settings_usecase.dart';
import '../../../setting/domain/entities/app_settings.dart';
import '../../../../core/usecases/usecase.dart';

part 'data_sync_state.dart';

@injectable
class DataSyncCubit extends Cubit<DataSyncState> {
  final SyncDataUseCase syncDataUseCase;
  final CheckDataExistenceUseCase checkDataExistenceUseCase;
  final GetSettingsUseCase getSettingsUseCase;

  DataSyncCubit(
    this.syncDataUseCase,
    this.checkDataExistenceUseCase,
    this.getSettingsUseCase,
  ) : super(DataSyncInitial());

  Future<void> checkData() async {
    emit(DataSyncLoading());
    final result = await checkDataExistenceUseCase(NoParams());
    result.fold(
      (failure) => emit(DataSyncError(failure.message)),
      (hasData) {
        if (hasData) {
          emit(DataSyncSuccess());
        } else {
          emit(DataSyncNeeded());
        }
      },
    );
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
    
    final result = await syncDataUseCase(
      SyncDataParams(
        apiKey: apiKey!,
        onProgress: (progress) {
          emit(DataSyncInProgress(progress));
        },
      ),
    );

    result.fold(
      (failure) => emit(DataSyncError(failure.message)),
      (_) => emit(DataSyncSuccess()),
    );
  }
}
