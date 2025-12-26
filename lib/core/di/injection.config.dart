// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/search/data/datasources/local_data_source.dart' as _i688;
import '../../features/search/data/datasources/remote_data_source.dart' as _i91;
import '../../features/search/data/repositories/food_repository_impl.dart'
    as _i64;
import '../../features/search/domain/repositories/i_food_repository.dart'
    as _i424;
import '../../features/search/domain/usecases/check_data_existence_usecase.dart'
    as _i938;
import '../../features/search/domain/usecases/get_raw_materials_usecase.dart'
    as _i806;
import '../../features/search/domain/usecases/get_storage_info_usecase.dart'
    as _i940;
import '../../features/search/domain/usecases/get_suggested_ingredients_usecase.dart'
    as _i918;
import '../../features/search/domain/usecases/refine_local_data_usecase.dart'
    as _i195;
import '../../features/search/domain/usecases/search_food_by_ingredients_usecase.dart'
    as _i337;
import '../../features/search/domain/usecases/search_food_by_name_usecase.dart'
    as _i924;
import '../../features/search/domain/usecases/sync_data_usecase.dart' as _i778;
import '../../features/search/presentation/bloc/data_sync_cubit.dart' as _i48;
import '../../features/search/presentation/bloc/ingredient_search_cubit.dart'
    as _i548;
import '../../features/search/presentation/bloc/search_cubit.dart' as _i77;
import '../../features/setting/data/repositories/settings_repository_impl.dart'
    as _i1025;
import '../../features/setting/domain/repositories/i_settings_repository.dart'
    as _i990;
import '../../features/setting/domain/usecases/check_update_needed_usecase.dart'
    as _i927;
import '../../features/setting/domain/usecases/export_food_data_usecase.dart'
    as _i601;
import '../../features/setting/domain/usecases/fetch_and_apply_remote_rules_usecase.dart'
    as _i913;
import '../../features/setting/domain/usecases/force_expire_sync_time_usecase.dart'
    as _i318;
import '../../features/setting/domain/usecases/get_settings_usecase.dart'
    as _i940;
import '../../features/setting/domain/usecases/save_api_key_usecase.dart'
    as _i152;
import '../../features/setting/domain/usecases/save_last_sync_time_usecase.dart'
    as _i526;
import '../../features/setting/domain/usecases/save_text_scale_usecase.dart'
    as _i775;
import '../../features/setting/domain/usecases/save_theme_mode_usecase.dart'
    as _i944;
import '../../features/setting/domain/usecases/save_update_interval_usecase.dart'
    as _i75;
import '../../features/setting/presentation/bloc/settings_cubit.dart' as _i291;
import '../config/remote_config_service.dart' as _i203;
import '../utils/excel_export_service.dart' as _i178;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i178.ExcelExportService>(
        () => _i178.ExcelExportService());
    gh.lazySingleton<_i91.RemoteDataSource>(
        () => _i91.RemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i990.ISettingsRepository>(
        () => _i1025.SettingsRepositoryImpl());
    gh.lazySingleton<_i688.LocalDataSource>(() => _i688.LocalDataSourceImpl());
    gh.lazySingleton<_i203.RemoteConfigService>(
        () => _i203.RemoteConfigService(gh<_i361.Dio>()));
    gh.factory<_i940.GetSettingsUseCase>(
        () => _i940.GetSettingsUseCase(gh<_i990.ISettingsRepository>()));
    gh.factory<_i944.SaveThemeModeUseCase>(
        () => _i944.SaveThemeModeUseCase(gh<_i990.ISettingsRepository>()));
    gh.factory<_i152.SaveApiKeyUseCase>(
        () => _i152.SaveApiKeyUseCase(gh<_i990.ISettingsRepository>()));
    gh.lazySingleton<_i318.ForceExpireSyncTimeUseCase>(() =>
        _i318.ForceExpireSyncTimeUseCase(gh<_i990.ISettingsRepository>()));
    gh.lazySingleton<_i927.CheckUpdateNeededUseCase>(
        () => _i927.CheckUpdateNeededUseCase(gh<_i990.ISettingsRepository>()));
    gh.lazySingleton<_i526.SaveLastSyncTimeUseCase>(
        () => _i526.SaveLastSyncTimeUseCase(gh<_i990.ISettingsRepository>()));
    gh.lazySingleton<_i775.SaveTextScaleUseCase>(
        () => _i775.SaveTextScaleUseCase(gh<_i990.ISettingsRepository>()));
    gh.lazySingleton<_i75.SaveUpdateIntervalUseCase>(
        () => _i75.SaveUpdateIntervalUseCase(gh<_i990.ISettingsRepository>()));
    gh.lazySingleton<_i601.ExportFoodDataUseCase>(
        () => _i601.ExportFoodDataUseCase(
              gh<_i688.LocalDataSource>(),
              gh<_i178.ExcelExportService>(),
            ));
    gh.lazySingleton<_i424.IFoodRepository>(() => _i64.FoodRepositoryImpl(
          gh<_i91.RemoteDataSource>(),
          gh<_i688.LocalDataSource>(),
        ));
    gh.lazySingleton<_i913.FetchAndApplyRemoteRulesUseCase>(
        () => _i913.FetchAndApplyRemoteRulesUseCase(
              gh<_i203.RemoteConfigService>(),
              gh<_i990.ISettingsRepository>(),
            ));
    gh.lazySingleton<_i940.GetStorageInfoUseCase>(
        () => _i940.GetStorageInfoUseCase(gh<_i424.IFoodRepository>()));
    gh.lazySingleton<_i806.GetRawMaterialsUseCase>(
        () => _i806.GetRawMaterialsUseCase(gh<_i424.IFoodRepository>()));
    gh.lazySingleton<_i337.SearchFoodByIngredientsUseCase>(() =>
        _i337.SearchFoodByIngredientsUseCase(gh<_i424.IFoodRepository>()));
    gh.factory<_i938.CheckDataExistenceUseCase>(
        () => _i938.CheckDataExistenceUseCase(gh<_i424.IFoodRepository>()));
    gh.factory<_i195.RefineLocalDataUseCase>(
        () => _i195.RefineLocalDataUseCase(gh<_i424.IFoodRepository>()));
    gh.factory<_i918.GetSuggestedIngredientsUseCase>(() =>
        _i918.GetSuggestedIngredientsUseCase(gh<_i424.IFoodRepository>()));
    gh.factory<_i778.SyncDataUseCase>(
        () => _i778.SyncDataUseCase(gh<_i424.IFoodRepository>()));
    gh.factory<_i924.SearchFoodByNameUseCase>(
        () => _i924.SearchFoodByNameUseCase(gh<_i424.IFoodRepository>()));
    gh.factory<_i291.SettingsCubit>(() => _i291.SettingsCubit(
          gh<_i940.GetSettingsUseCase>(),
          gh<_i152.SaveApiKeyUseCase>(),
          gh<_i775.SaveTextScaleUseCase>(),
          gh<_i601.ExportFoodDataUseCase>(),
          gh<_i195.RefineLocalDataUseCase>(),
          gh<_i75.SaveUpdateIntervalUseCase>(),
          gh<_i318.ForceExpireSyncTimeUseCase>(),
          gh<_i944.SaveThemeModeUseCase>(),
          gh<_i913.FetchAndApplyRemoteRulesUseCase>(),
        ));
    gh.factory<_i548.IngredientSearchCubit>(() => _i548.IngredientSearchCubit(
          gh<_i337.SearchFoodByIngredientsUseCase>(),
          gh<_i918.GetSuggestedIngredientsUseCase>(),
        ));
    gh.factory<_i77.SearchCubit>(
        () => _i77.SearchCubit(gh<_i924.SearchFoodByNameUseCase>()));
    gh.lazySingleton<_i48.DataSyncCubit>(() => _i48.DataSyncCubit(
          gh<_i778.SyncDataUseCase>(),
          gh<_i938.CheckDataExistenceUseCase>(),
          gh<_i940.GetSettingsUseCase>(),
          gh<_i940.GetStorageInfoUseCase>(),
          gh<_i526.SaveLastSyncTimeUseCase>(),
          gh<_i927.CheckUpdateNeededUseCase>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
