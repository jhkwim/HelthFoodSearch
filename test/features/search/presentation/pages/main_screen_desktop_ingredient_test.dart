import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Added import at top
import 'package:health_food_search/features/search/presentation/pages/main_screen.dart';
import 'package:health_food_search/features/search/presentation/bloc/ingredient_search_cubit.dart';
import 'package:health_food_search/features/search/presentation/bloc/search_cubit.dart';
import 'package:health_food_search/features/search/presentation/bloc/data_sync_cubit.dart';

import 'package:health_food_search/features/search/domain/usecases/search_food_by_ingredients_usecase.dart';
import 'package:health_food_search/features/search/domain/usecases/get_suggested_ingredients_usecase.dart';
import 'package:health_food_search/features/search/domain/usecases/search_food_by_name_usecase.dart';
import 'package:health_food_search/features/search/domain/usecases/sync_data_usecase.dart';
import 'package:health_food_search/features/search/domain/usecases/check_data_existence_usecase.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';
import 'package:health_food_search/l10n/app_localizations.dart';

import 'package:health_food_search/features/setting/domain/usecases/get_settings_usecase.dart';
import 'package:health_food_search/features/search/domain/usecases/get_storage_info_usecase.dart';
import 'package:health_food_search/features/setting/domain/usecases/save_last_sync_time_usecase.dart';
import 'package:health_food_search/features/setting/domain/usecases/check_update_needed_usecase.dart';
import 'package:health_food_search/features/setting/domain/usecases/fetch_and_apply_remote_rules_usecase.dart';
import 'package:health_food_search/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:health_food_search/core/error/failures.dart';
import 'package:health_food_search/features/search/domain/entities/storage_info.dart';
import 'package:health_food_search/features/search/domain/entities/food_item.dart';
import 'package:health_food_search/features/search/domain/entities/ingredient.dart';

// Mocks
class MockSearchFoodByIngredientsUseCase extends Mock
    implements SearchFoodByIngredientsUseCase {
  @override
  Future<Either<Failure, List<FoodItem>>> call(
    SearchFoodByIngredientsParams params,
  ) async {
    return super.noSuchMethod(Invocation.method(#call, [params])) ??
        Future.value(const Right([]));
  }
}

class MockGetSuggestedIngredientsUseCase extends Mock
    implements GetSuggestedIngredientsUseCase {
  @override
  Future<Either<Failure, List<Ingredient>>> call(String params) async {
    return super.noSuchMethod(Invocation.method(#call, [params])) ??
        Future.value(const Right([]));
  }
}

class MockSearchFoodByNameUseCase extends Mock
    implements SearchFoodByNameUseCase {}

class MockSyncDataUseCase extends Mock implements SyncDataUseCase {}

class MockCheckDataExistenceUseCase extends Mock
    implements CheckDataExistenceUseCase {
  @override
  Future<Either<Failure, bool>> call(NoParams params) async =>
      super.noSuchMethod(Invocation.method(#call, [params])) ??
      Future.value(const Right(false));
}

class MockGetSettingsUseCase extends Mock implements GetSettingsUseCase {}

class MockGetStorageInfoUseCase extends Mock implements GetStorageInfoUseCase {
  @override
  Future<Either<Failure, StorageInfo>> call(NoParams params) async =>
      super.noSuchMethod(Invocation.method(#call, [params])) ??
      Future.value(const Right(StorageInfo(count: 0, sizeBytes: 0)));
}

class MockSaveLastSyncTimeUseCase extends Mock
    implements SaveLastSyncTimeUseCase {}

class MockCheckUpdateNeededUseCase extends Mock
    implements CheckUpdateNeededUseCase {
  @override
  Future<Either<Failure, bool>> call(NoParams params) async =>
      super.noSuchMethod(Invocation.method(#call, [params])) ??
      Future.value(const Right(false));
}

class MockFetchAndApplyRemoteRulesUseCase extends Mock
    implements FetchAndApplyRemoteRulesUseCase {}

void main() {
  late IngredientSearchCubit ingredientSearchCubit;
  late SearchCubit searchCubit;
  late DataSyncCubit dataSyncCubit;

  late MockSearchFoodByIngredientsUseCase mockSearchFoodByIngredients;
  late MockGetSuggestedIngredientsUseCase mockGetSuggestedIngredients;
  late MockSearchFoodByNameUseCase mockSearchFoodByName;
  late MockSyncDataUseCase mockSyncData;
  late MockCheckDataExistenceUseCase mockCheckData;
  late MockGetSettingsUseCase mockGetSettings;
  late MockGetStorageInfoUseCase mockGetStorageInfo;
  late MockSaveLastSyncTimeUseCase mockSaveLastSyncTime;
  late MockCheckUpdateNeededUseCase mockCheckUpdateNeeded;
  late MockFetchAndApplyRemoteRulesUseCase mockFetchAndApplyRemoteRulesUseCase;

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(const SearchFoodByIngredientsParams(ingredients: []));

    final getIt = GetIt.instance;
    // Clearing existing if any (safe)
    if (getIt.isRegistered<SearchFoodByIngredientsUseCase>())
      getIt.unregister<SearchFoodByIngredientsUseCase>();
    if (getIt.isRegistered<GetSuggestedIngredientsUseCase>())
      getIt.unregister<GetSuggestedIngredientsUseCase>();

    getIt.registerLazySingleton<SearchFoodByIngredientsUseCase>(
      () => MockSearchFoodByIngredientsUseCase(),
    );
    getIt.registerLazySingleton<GetSuggestedIngredientsUseCase>(
      () => MockGetSuggestedIngredientsUseCase(),
    );
  });

  setUp(() {
    mockSearchFoodByIngredients = MockSearchFoodByIngredientsUseCase();
    mockGetSuggestedIngredients = MockGetSuggestedIngredientsUseCase();
    mockSearchFoodByName = MockSearchFoodByNameUseCase();
    mockSyncData = MockSyncDataUseCase();
    mockCheckData = MockCheckDataExistenceUseCase();
    mockGetSettings = MockGetSettingsUseCase();
    mockGetStorageInfo = MockGetStorageInfoUseCase();
    mockSaveLastSyncTime = MockSaveLastSyncTimeUseCase();
    mockCheckUpdateNeeded = MockCheckUpdateNeededUseCase();
    mockFetchAndApplyRemoteRulesUseCase = MockFetchAndApplyRemoteRulesUseCase();

    // Mock behaviors for initializing MainScreen
    when(
      () => mockCheckData.call(any()),
    ).thenAnswer((_) async => const Right(true));
    when(() => mockGetStorageInfo.call(any())).thenAnswer(
      (_) async => const Right(StorageInfo(count: 100, sizeBytes: 1024)),
    );
    when(
      () => mockCheckUpdateNeeded.call(any()),
    ).thenAnswer((_) async => const Right(false));

    // Mock behaviors for Ingredient Search
    when(
      () => mockGetSuggestedIngredients.call(any()),
    ).thenAnswer((_) async => const Right([]));
    when(
      () => mockSearchFoodByIngredients.call(any()),
    ).thenAnswer((_) async => const Right([]));

    ingredientSearchCubit = IngredientSearchCubit(
      mockSearchFoodByIngredients,
      mockGetSuggestedIngredients,
    );
    searchCubit = SearchCubit(mockSearchFoodByName);
    dataSyncCubit = DataSyncCubit(
      mockSyncData,
      mockCheckData,
      mockGetSettings,
      mockGetStorageInfo,
      mockSaveLastSyncTime,
      mockCheckUpdateNeeded,
      mockFetchAndApplyRemoteRulesUseCase,
    );

    final getIt = GetIt.instance;
    if (getIt.isRegistered<IngredientSearchCubit>())
      getIt.unregister<IngredientSearchCubit>();
    if (getIt.isRegistered<SearchCubit>()) getIt.unregister<SearchCubit>();
    if (getIt.isRegistered<DataSyncCubit>()) getIt.unregister<DataSyncCubit>();

    getIt.registerSingleton<IngredientSearchCubit>(ingredientSearchCubit);
    getIt.registerSingleton<SearchCubit>(searchCubit);
    getIt.registerSingleton<DataSyncCubit>(dataSyncCubit);
  });

  tearDown(() {
    final getIt = GetIt.instance;
    getIt.reset();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider(
        create: (context) => GetIt.instance<DataSyncCubit>(),
        child: const MainScreen(),
      ),
    );
  }

  testWidgets('Desktop: Ingredient selection adds chip and clears text', (
    WidgetTester tester,
  ) async {
    // Arrange
    await tester.binding.setSurfaceSize(const Size(1024, 768)); // Desktop Size
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Act
    // 1. Switch to Ingredient Search Tab
    // In Desktop, tabs are in the left panel.
    await tester.tap(find.text('원료별 검색'));
    await tester.pumpAndSettle();

    // 2. Enter '철'
    final textField = find.byType(
      TextField,
    ); // Should find one in IngredientSearchTab
    expect(textField, findsOneWidget);
    await tester.enterText(textField, '철');
    await tester.pumpAndSettle();

    // 3. Submit (or tap add icon)
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // Assert
    // Check if Chip is present
    expect(find.byType(Chip), findsOneWidget);
    expect(find.text('철'), findsOneWidget);

    // Check if Text Field is cleared
    // Note: entered text usually stays in finder until reset, but controller should be empty.
    final EditableText editableText = tester.widget(
      find.byType(EditableText).first,
    );
    expect(editableText.controller.text, isEmpty);
  });
}
