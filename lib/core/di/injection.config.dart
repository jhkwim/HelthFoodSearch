// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/search/data/datasources/local_data_source.dart' as _i688;
import '../../features/search/data/datasources/remote_data_source.dart' as _i91;
import '../../features/search/data/repositories/food_repository_impl.dart'
    as _i64;
import '../../features/search/domain/repositories/i_food_repository.dart'
    as _i424;
import '../../features/search/domain/usecases/get_suggested_ingredients_usecase.dart'
    as _i918;
import '../../features/search/domain/usecases/search_food_by_ingredients_usecase.dart'
    as _i337;
import '../../features/search/domain/usecases/search_food_by_name_usecase.dart'
    as _i924;
import '../../features/search/domain/usecases/sync_data_usecase.dart' as _i778;
import '../../features/setting/data/repositories/settings_repository_impl.dart'
    as _i1025;
import '../../features/setting/domain/repositories/i_settings_repository.dart'
    as _i990;
import '../../features/setting/domain/usecases/get_settings_usecase.dart'
    as _i940;
import '../../features/setting/domain/usecases/save_api_key_usecase.dart'
    as _i152;
import 'register_module.dart' as _i291;
import 'storage_module.dart' as _i371;

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
    final storageModule = _$StorageModule();
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => storageModule.secureStorage);
    gh.lazySingleton<_i91.RemoteDataSource>(
        () => _i91.RemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i688.LocalDataSource>(() => _i688.LocalDataSourceImpl());
    gh.lazySingleton<_i424.IFoodRepository>(() => _i64.FoodRepositoryImpl(
          gh<InvalidType>(),
          gh<InvalidType>(),
        ));
    gh.lazySingleton<_i990.ISettingsRepository>(
        () => _i1025.SettingsRepositoryImpl(gh<_i558.FlutterSecureStorage>()));
    gh.factory<_i940.GetSettingsUseCase>(
        () => _i940.GetSettingsUseCase(gh<_i990.ISettingsRepository>()));
    gh.factory<_i152.SaveApiKeyUseCase>(
        () => _i152.SaveApiKeyUseCase(gh<_i990.ISettingsRepository>()));
    gh.factory<_i918.GetSuggestedIngredientsUseCase>(() =>
        _i918.GetSuggestedIngredientsUseCase(gh<_i424.IFoodRepository>()));
    gh.factory<_i778.SyncDataUseCase>(
        () => _i778.SyncDataUseCase(gh<_i424.IFoodRepository>()));
    gh.factory<_i337.SearchFoodByIngredientsUseCase>(() =>
        _i337.SearchFoodByIngredientsUseCase(gh<_i424.IFoodRepository>()));
    gh.factory<_i924.SearchFoodByNameUseCase>(
        () => _i924.SearchFoodByNameUseCase(gh<_i424.IFoodRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}

class _$StorageModule extends _i371.StorageModule {}
