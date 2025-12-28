import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_food_search/core/error/failures.dart';
import 'package:health_food_search/core/usecases/usecase.dart';
import 'package:health_food_search/features/search/domain/entities/storage_info.dart';
import 'package:health_food_search/features/search/domain/usecases/check_data_existence_usecase.dart';
import 'package:health_food_search/features/search/domain/usecases/get_storage_info_usecase.dart';
import 'package:health_food_search/features/search/domain/usecases/sync_data_usecase.dart';
import 'package:health_food_search/features/search/presentation/bloc/data_sync_cubit.dart';
import 'package:health_food_search/features/setting/domain/entities/app_settings.dart';
import 'package:health_food_search/features/setting/domain/usecases/check_update_needed_usecase.dart';
import 'package:health_food_search/features/setting/domain/usecases/fetch_and_apply_remote_rules_usecase.dart';
import 'package:health_food_search/features/setting/domain/usecases/get_settings_usecase.dart';
import 'package:health_food_search/features/setting/domain/usecases/save_last_sync_time_usecase.dart';
import 'package:health_food_search/features/search/domain/usecases/clear_data_usecase.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockSyncDataUseCase extends Mock implements SyncDataUseCase {}

class MockCheckDataExistenceUseCase extends Mock
    implements CheckDataExistenceUseCase {}

class MockGetSettingsUseCase extends Mock implements GetSettingsUseCase {}

class MockGetStorageInfoUseCase extends Mock implements GetStorageInfoUseCase {}

class MockSaveLastSyncTimeUseCase extends Mock
    implements SaveLastSyncTimeUseCase {}

class MockCheckUpdateNeededUseCase extends Mock
    implements CheckUpdateNeededUseCase {}

class MockFetchAndApplyRemoteRulesUseCase extends Mock
    implements FetchAndApplyRemoteRulesUseCase {}

class MockClearDataUseCase extends Mock implements ClearDataUseCase {}

void main() {
  late DataSyncCubit cubit;
  late MockSyncDataUseCase mockSyncData;
  late MockCheckDataExistenceUseCase mockCheckData;
  late MockGetSettingsUseCase mockGetSettings;
  late MockGetStorageInfoUseCase mockGetStorageInfo;
  late MockSaveLastSyncTimeUseCase mockSaveLastSyncTime;
  late MockCheckUpdateNeededUseCase mockCheckUpdateNeeded;
  late MockFetchAndApplyRemoteRulesUseCase mockFetchRules;
  late MockClearDataUseCase mockClearDataUseCase;

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(DateTime.now());
    registerFallbackValue(SyncDataParams(apiKey: 'test'));
  });

  setUp(() {
    mockSyncData = MockSyncDataUseCase();
    mockCheckData = MockCheckDataExistenceUseCase();
    mockGetSettings = MockGetSettingsUseCase();
    mockGetStorageInfo = MockGetStorageInfoUseCase();
    mockSaveLastSyncTime = MockSaveLastSyncTimeUseCase();
    mockCheckUpdateNeeded = MockCheckUpdateNeededUseCase();
    mockFetchRules = MockFetchAndApplyRemoteRulesUseCase();
    mockClearDataUseCase = MockClearDataUseCase();

    cubit = DataSyncCubit(
      mockSyncData,
      mockCheckData,
      mockGetSettings,
      mockGetStorageInfo,
      mockSaveLastSyncTime,
      mockCheckUpdateNeeded,
      mockFetchRules,
      mockClearDataUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('DataSyncCubit', () {
    group('checkData', () {
      blocTest<DataSyncCubit, DataSyncState>(
        '데이터가 있는 경우 DataSyncSuccess 상태',
        build: () {
          when(
            () => mockCheckData(any()),
          ).thenAnswer((_) async => const Right(true));
          when(() => mockGetStorageInfo(any())).thenAnswer(
            (_) async => const Right(StorageInfo(count: 100, sizeBytes: 1024)),
          );
          when(
            () => mockCheckUpdateNeeded(any()),
          ).thenAnswer((_) async => const Right(false));
          return cubit;
        },
        act: (cubit) => cubit.checkData(),
        expect: () => [
          isA<DataSyncLoading>(),
          isA<DataSyncSuccess>().having(
            (s) => s.storageInfo?.count,
            'count',
            100,
          ),
        ],
      );

      blocTest<DataSyncCubit, DataSyncState>(
        '데이터가 없는 경우 DataSyncNeeded 상태',
        build: () {
          when(
            () => mockCheckData(any()),
          ).thenAnswer((_) async => const Right(false));
          return cubit;
        },
        act: (cubit) => cubit.checkData(),
        expect: () => [isA<DataSyncLoading>(), isA<DataSyncNeeded>()],
      );

      blocTest<DataSyncCubit, DataSyncState>(
        '데이터 확인 실패 시 DataSyncError 상태',
        build: () {
          when(
            () => mockCheckData(any()),
          ).thenAnswer((_) async => const Left(CacheFailure('DB 오류')));
          return cubit;
        },
        act: (cubit) => cubit.checkData(),
        expect: () => [
          isA<DataSyncLoading>(),
          isA<DataSyncError>().having(
            (s) => s.failure,
            'failure',
            isA<CacheFailure>(),
          ),
        ],
      );

      blocTest<DataSyncCubit, DataSyncState>(
        '업데이트가 필요한 경우 updateNeeded=true',
        build: () {
          when(
            () => mockCheckData(any()),
          ).thenAnswer((_) async => const Right(true));
          when(() => mockGetStorageInfo(any())).thenAnswer(
            (_) async => const Right(StorageInfo(count: 100, sizeBytes: 1024)),
          );
          when(
            () => mockCheckUpdateNeeded(any()),
          ).thenAnswer((_) async => const Right(true));
          return cubit;
        },
        act: (cubit) => cubit.checkData(),
        expect: () => [
          isA<DataSyncLoading>(),
          isA<DataSyncSuccess>().having(
            (s) => s.updateNeeded,
            'updateNeeded',
            true,
          ),
        ],
      );
    });

    group('syncData', () {
      const tSettings = AppSettings(apiKey: 'test-api-key');

      blocTest<DataSyncCubit, DataSyncState>(
        'API Key가 없는 경우 DataSyncError 상태',
        build: () {
          when(
            () => mockGetSettings(any()),
          ).thenAnswer((_) async => const Right(AppSettings(apiKey: null)));
          return cubit;
        },
        act: (cubit) => cubit.syncData(),
        expect: () => [
          isA<DataSyncError>().having(
            (s) => s.failure,
            'failure',
            isA<ApiKeyMissingFailure>(),
          ),
        ],
      );

      blocTest<DataSyncCubit, DataSyncState>(
        '동기화 성공 시 DataSyncSuccess 상태',
        build: () {
          when(
            () => mockGetSettings(any()),
          ).thenAnswer((_) async => const Right(tSettings));
          when(() => mockFetchRules.execute()).thenAnswer((_) async => false);
          when(
            () => mockSyncData(any()),
          ).thenAnswer((_) async => const Right(null));
          when(
            () => mockSaveLastSyncTime(any()),
          ).thenAnswer((_) async => const Right(null));
          when(() => mockGetStorageInfo(any())).thenAnswer(
            (_) async => const Right(StorageInfo(count: 200, sizeBytes: 2048)),
          );
          return cubit;
        },
        act: (cubit) => cubit.syncData(),
        expect: () => [
          isA<DataSyncInProgress>(),
          isA<DataSyncSuccess>().having(
            (s) => s.storageInfo?.count,
            'count',
            200,
          ),
        ],
      );

      blocTest<DataSyncCubit, DataSyncState>(
        '동기화 실패 시 DataSyncError 상태',
        build: () {
          when(
            () => mockGetSettings(any()),
          ).thenAnswer((_) async => const Right(tSettings));
          when(() => mockFetchRules.execute()).thenAnswer((_) async => false);
          when(
            () => mockSyncData(any()),
          ).thenAnswer((_) async => const Left(ServerFailure('서버 오류')));
          return cubit;
        },
        act: (cubit) => cubit.syncData(),
        expect: () => [
          isA<DataSyncInProgress>(),
          isA<DataSyncError>().having(
            (s) => s.failure,
            'failure',
            isA<ServerFailure>(),
          ),
        ],
      );
    });
  });
}
