import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:health_food_search/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/search/data/models/food_item_hive_model.dart';
import 'features/search/data/models/raw_material_hive_model.dart';
import 'features/favorite/data/models/favorite_hive_model.dart';
import 'features/favorite/data/models/search_history_hive_model.dart';
import 'features/search/presentation/bloc/data_sync_cubit.dart';
import 'config/routes/app_router.dart';
import 'config/theme/app_theme.dart';
import 'core/di/injection.dart';

import 'features/setting/domain/usecases/fetch_and_apply_remote_rules_usecase.dart';
import 'features/setting/presentation/bloc/settings_cubit.dart';
import 'features/search/domain/usecases/refine_local_data_usecase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(FoodItemHiveModelAdapter());
  Hive.registerAdapter(RawMaterialHiveModelAdapter());
  Hive.registerAdapter(FavoriteHiveModelAdapter());
  Hive.registerAdapter(SearchHistoryHiveModelAdapter());
  await Hive.openBox('settings'); // Open settings box

  configureDependencies();

  // Initialize remote refinement rules & Conditional Refinement
  getIt<FetchAndApplyRemoteRulesUseCase>().execute().then((hasChanged) {
    if (hasChanged) {
      debugPrint('Remote rules updated. Starting background refinement...');
      getIt<RefineLocalDataUseCase>().call().listen(
        (progress) {},
        onDone: () => debugPrint('Background refinement completed.'),
        onError: (e) => debugPrint('Background refinement error: $e'),
      );
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<DataSyncCubit>()),
        BlocProvider(
          create: (context) => getIt<SettingsCubit>()..checkSettings(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<DataSyncCubit, DataSyncState>(
            listener: (context, state) {
              if (state is DataSyncSuccess) {
                context.read<SettingsCubit>().checkSettings();
              }
            },
          ),
        ],
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            double textScale = 1.0;
            ThemeMode themeMode = ThemeMode.system;
            if (state is SettingsLoaded) {
              textScale = state.settings.textScale;
              themeMode = state.settings.themeMode;
            }

            return MaterialApp.router(
              onGenerateTitle: (context) =>
                  AppLocalizations.of(context)!.appTitle,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [Locale('ko')],
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme, // New
              themeMode: themeMode, // New
              routerConfig: appRouter,
              debugShowCheckedModeBanner: false,
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: TextScaler.linear(textScale)),
                  child: child!,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
