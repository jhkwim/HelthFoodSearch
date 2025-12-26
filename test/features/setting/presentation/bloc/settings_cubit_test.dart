import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_food_search/features/setting/domain/entities/app_settings.dart';
import 'package:health_food_search/features/setting/domain/usecases/get_settings_usecase.dart';
import 'package:health_food_search/features/setting/domain/usecases/save_theme_mode_usecase.dart';
import 'package:health_food_search/features/setting/presentation/bloc/settings_cubit.dart';
import 'package:mocktail/mocktail.dart';

import 'package:health_food_search/core/usecases/usecase.dart';
import 'package:health_food_search/features/setting/domain/usecases/save_api_key_usecase.dart';
import 'package:health_food_search/features/setting/domain/usecases/save_text_scale_usecase.dart';
import 'package:health_food_search/features/setting/domain/usecases/export_food_data_usecase.dart';
import 'package:health_food_search/features/search/domain/usecases/refine_local_data_usecase.dart';
import 'package:health_food_search/features/setting/domain/usecases/save_update_interval_usecase.dart';
import 'package:health_food_search/features/setting/domain/usecases/force_expire_sync_time_usecase.dart';
import 'package:health_food_search/features/setting/domain/usecases/fetch_and_apply_remote_rules_usecase.dart';

class MockGetSettingsUseCase extends Mock implements GetSettingsUseCase {}

class MockSaveApiKeyUseCase extends Mock implements SaveApiKeyUseCase {}

class MockSaveTextScaleUseCase extends Mock implements SaveTextScaleUseCase {}

class MockExportFoodDataUseCase extends Mock implements ExportFoodDataUseCase {}

class MockRefineLocalDataUseCase extends Mock
    implements RefineLocalDataUseCase {}

class MockSaveUpdateIntervalUseCase extends Mock
    implements SaveUpdateIntervalUseCase {}

class MockForceExpireSyncTimeUseCase extends Mock
    implements ForceExpireSyncTimeUseCase {}

class MockSaveThemeModeUseCase extends Mock implements SaveThemeModeUseCase {}

class MockFetchAndApplyRemoteRulesUseCase extends Mock
    implements FetchAndApplyRemoteRulesUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SettingsCubit cubit;
  late MockGetSettingsUseCase mockGetSettingsUseCase;
  late MockSaveApiKeyUseCase mockSaveApiKeyUseCase;
  late MockSaveTextScaleUseCase mockSaveTextScaleUseCase;
  late MockExportFoodDataUseCase mockExportFoodDataUseCase;
  late MockRefineLocalDataUseCase mockRefineLocalDataUseCase;
  late MockSaveUpdateIntervalUseCase mockSaveUpdateIntervalUseCase;
  late MockForceExpireSyncTimeUseCase mockForceExpireSyncTimeUseCase;
  late MockSaveThemeModeUseCase mockSaveThemeModeUseCase;
  late MockFetchAndApplyRemoteRulesUseCase mockFetchAndApplyRemoteRulesUseCase;

  setUp(() {
    mockGetSettingsUseCase = MockGetSettingsUseCase();
    mockSaveApiKeyUseCase = MockSaveApiKeyUseCase();
    mockSaveTextScaleUseCase = MockSaveTextScaleUseCase();
    mockExportFoodDataUseCase = MockExportFoodDataUseCase();
    mockRefineLocalDataUseCase = MockRefineLocalDataUseCase();
    mockSaveUpdateIntervalUseCase = MockSaveUpdateIntervalUseCase();
    mockForceExpireSyncTimeUseCase = MockForceExpireSyncTimeUseCase();
    mockSaveThemeModeUseCase = MockSaveThemeModeUseCase();
    mockFetchAndApplyRemoteRulesUseCase = MockFetchAndApplyRemoteRulesUseCase();

    cubit = SettingsCubit(
      mockGetSettingsUseCase,
      mockSaveApiKeyUseCase,
      mockSaveTextScaleUseCase,
      mockExportFoodDataUseCase,
      mockRefineLocalDataUseCase,
      mockSaveUpdateIntervalUseCase,
      mockForceExpireSyncTimeUseCase,
      mockSaveThemeModeUseCase,
      mockFetchAndApplyRemoteRulesUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('SettingsCubit ThemeMode', () {
    const tSettings = AppSettings(themeMode: ThemeMode.system);

    test('initial state is SettingsInitial', () {
      expect(cubit.state, equals(SettingsInitial()));
    });

    blocTest<SettingsCubit, SettingsState>(
      'emits [SettingsLoading, SettingsLoaded] when checkSettings is called',
      build: () {
        when(
          () => mockGetSettingsUseCase(NoParams()),
        ).thenAnswer((_) async => const Right(tSettings));
        return cubit;
      },
      act: (cubit) => cubit.checkSettings(),
      expect: () => [
        SettingsLoading(),
        isA<SettingsLoaded>().having(
          (s) => s.settings.themeMode,
          'themeMode',
          ThemeMode.system,
        ),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'emits correct states when saveThemeMode is called',
      build: () {
        when(
          () => mockSaveThemeModeUseCase(ThemeMode.dark),
        ).thenAnswer((_) async => const Right(null));
        when(() => mockGetSettingsUseCase(NoParams())).thenAnswer(
          (_) async => const Right(AppSettings(themeMode: ThemeMode.dark)),
        );
        return cubit;
      },
      act: (cubit) => cubit.saveThemeMode(ThemeMode.dark),
      expect: () => [
        SettingsLoading(),
        // Second SettingsLoading skipped because state didn't change (Loading -> Loading)
        isA<SettingsLoaded>().having(
          (s) => s.settings.themeMode,
          'themeMode',
          ThemeMode.dark,
        ),
      ],
      verify: (_) {
        verify(() => mockSaveThemeModeUseCase(ThemeMode.dark)).called(1);
        verify(() => mockGetSettingsUseCase(NoParams())).called(1);
      },
    );
  });
}
