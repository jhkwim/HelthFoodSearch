import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:health_food_search/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/search/data/models/food_item_hive_model.dart';
import 'features/search/data/models/raw_material_hive_model.dart';
import 'features/search/presentation/bloc/data_sync_cubit.dart';
import 'config/routes/app_router.dart';
import 'config/theme/app_theme.dart';
import 'core/di/injection.dart';

import 'features/setting/presentation/bloc/settings_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  Hive.registerAdapter(FoodItemHiveModelAdapter());
  Hive.registerAdapter(RawMaterialHiveModelAdapter());
  await Hive.openBox('settings'); // Open settings box
  
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<DataSyncCubit>()..checkData()),
        BlocProvider(create: (context) => getIt<SettingsCubit>()..checkSettings()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          double textScale = 1.0;
          if (state is SettingsLoaded) {
            textScale = state.settings.textScale;
          }
          
          return MaterialApp.router(
            onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ko'),
            ],
            theme: AppTheme.lightTheme,
            routerConfig: appRouter,
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(textScale),
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
