import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_food_search/features/search/presentation/pages/main_screen.dart';
import 'package:health_food_search/features/search/presentation/bloc/ingredient_search_cubit.dart';
import 'package:health_food_search/features/search/presentation/bloc/search_cubit.dart';
import 'package:health_food_search/features/search/presentation/bloc/data_sync_cubit.dart'; // Correct path

import 'package:health_food_search/features/search/domain/usecases/search_food_by_ingredients_usecase.dart';
import 'package:health_food_search/features/search/domain/usecases/get_suggested_ingredients_usecase.dart';
import 'package:health_food_search/features/search/domain/usecases/search_food_by_name_usecase.dart';
import 'package:health_food_search/features/search/domain/usecases/sync_data_usecase.dart'; // Correct: search domain
import 'package:health_food_search/features/search/domain/usecases/check_data_existence_usecase.dart'; // Correct: search domain
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';
import 'package:health_food_search/l10n/app_localizations.dart';

import 'package:health_food_search/features/setting/domain/usecases/get_settings_usecase.dart';
import 'package:health_food_search/features/search/domain/usecases/get_storage_info_usecase.dart';
import 'package:health_food_search/features/setting/domain/usecases/save_last_sync_time_usecase.dart';
import 'package:health_food_search/features/setting/domain/usecases/check_update_needed_usecase.dart';
import 'package:health_food_search/core/usecases/usecase.dart'; // For NoParams
import 'package:dartz/dartz.dart'; // For Right
import 'package:health_food_search/core/error/failures.dart'; // For Failure
import 'package:health_food_search/features/search/domain/entities/storage_info.dart';

class MockSearchFoodByIngredientsUseCase extends Mock implements SearchFoodByIngredientsUseCase {}
class MockGetSuggestedIngredientsUseCase extends Mock implements GetSuggestedIngredientsUseCase {}
class MockSearchFoodByNameUseCase extends Mock implements SearchFoodByNameUseCase {}
class MockSyncDataUseCase extends Mock implements SyncDataUseCase {}
class MockCheckDataExistenceUseCase extends Mock implements CheckDataExistenceUseCase {
  @override
  Future<Either<Failure, bool>> call(NoParams params) => super.noSuchMethod(Invocation.method(#call, [params]));
}
class MockGetSettingsUseCase extends Mock implements GetSettingsUseCase {}
class MockGetStorageInfoUseCase extends Mock implements GetStorageInfoUseCase {
   @override
  Future<Either<Failure, StorageInfo>> call(NoParams params) => super.noSuchMethod(Invocation.method(#call, [params]));
}
class MockSaveLastSyncTimeUseCase extends Mock implements SaveLastSyncTimeUseCase {}
class MockCheckUpdateNeededUseCase extends Mock implements CheckUpdateNeededUseCase {
  @override
  Future<Either<Failure, bool>> call(NoParams params) => super.noSuchMethod(Invocation.method(#call, [params]));
}

void main() {
  late IngredientSearchCubit ingredientSearchCubit;
  late SearchCubit searchCubit;
  late DataSyncCubit dataSyncCubit;
  
  setUp(() {
    final getIt = GetIt.instance;
    getIt.reset();
    
    final mockSearchFoodByIngredients = MockSearchFoodByIngredientsUseCase();
    final mockGetSuggestedIngredients = MockGetSuggestedIngredientsUseCase();
    final mockSearchFoodByName = MockSearchFoodByNameUseCase();
    final mockSyncData = MockSyncDataUseCase();
    final mockCheckData = MockCheckDataExistenceUseCase();
    final mockGetSettings = MockGetSettingsUseCase();
    final mockGetStorageInfo = MockGetStorageInfoUseCase();
    final mockSaveLastSyncTime = MockSaveLastSyncTimeUseCase();
    final mockCheckUpdateNeeded = MockCheckUpdateNeededUseCase();

    // Register fallback values
    registerFallbackValue(NoParams());
    registerFallbackValue(const SearchFoodByIngredientsParams(ingredients: []));

    // Mock behaviors for initializing MainScreen
    when(() => mockCheckData.call(any())).thenAnswer((_) async => const Right(true));
    when(() => mockGetStorageInfo.call(any())).thenAnswer((_) async => const Right(StorageInfo(count: 100, sizeBytes: 1024)));
    when(() => mockCheckUpdateNeeded.call(any())).thenAnswer((_) async => const Right(false));
    
    // Mock behaviors for Ingredient Search
    when(() => mockGetSuggestedIngredients.call(any())).thenAnswer((_) async => const Right([]));
    when(() => mockSearchFoodByIngredients.call(any())).thenAnswer((_) async => const Right([]));

    ingredientSearchCubit = IngredientSearchCubit(mockSearchFoodByIngredients, mockGetSuggestedIngredients);
    searchCubit = SearchCubit(mockSearchFoodByName);
    dataSyncCubit = DataSyncCubit(
      mockSyncData, 
      mockCheckData,
      mockGetSettings,
      mockGetStorageInfo,
      mockSaveLastSyncTime,
      mockCheckUpdateNeeded
    );
    
    getIt.registerSingleton<IngredientSearchCubit>(ingredientSearchCubit);
    getIt.registerSingleton<SearchCubit>(searchCubit);
    getIt.registerSingleton<DataSyncCubit>(dataSyncCubit);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider.value(
        value: dataSyncCubit,
        child: const MainScreen(),
      ),
    );
  }

  testWidgets('Ingredient selection adds chip to header in MainScreen', (WidgetTester tester) async {
    // Arrange
    //when(() => ingredientSearchCubit.stream).thenAnswer((_) => Stream.value(IngredientSearchState()));
       await tester.binding.setSurfaceSize(const Size(400, 800));
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Act - Switch to Ingredient Tab
    await tester.tap(find.text('원료별 검색')); // Assuming localization 'Ingredient Search' -> '원료별 검색' or similar. 
    // Wait, let's use the localized text from context or key if possible. 
    // Or just find by Tab index?
    await tester.pumpAndSettle();
    
    // Check if Header shows Ingredient Search Field
    final textField = find.byType(TextField).at(0); // Should be the one in header
    expect(textField, findsOneWidget);
    
    // Act - Type '철' and Submit
    await tester.enterText(textField, '철');
    await tester.testTextInput.receiveAction(TextInputAction.search); // or submit
    // MainScreen uses onSubmitted.
    // await tester.rest(); // trigger onSubmitted?
    
    // Manual trigger onSubmitted since enterText doesn't always do it?
    // Actually `testTextInput.receiveAction(TextInputAction.done)` might work.
    // Or finding the TextField and calling onSubmitted.
    
    // Let's use the Add Icon Button
    final addButton = find.byIcon(Icons.add_circle);
    expect(addButton, findsOneWidget);
    await tester.tap(addButton);
    await tester.pump();

    // Assert
    // Check if '철' chip is displayed in Header
    expect(find.widgetWithText(Chip, '철'), findsOneWidget);
  });
}
