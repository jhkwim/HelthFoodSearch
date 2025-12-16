import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../features/setting/presentation/pages/api_key_screen.dart';
import '../../features/setting/presentation/pages/settings_screen.dart';
import '../../features/search/presentation/pages/download_screen.dart';
import '../../features/search/presentation/pages/main_screen.dart';
import '../../features/search/presentation/pages/detail_screen.dart';
import '../../features/search/domain/entities/food_item.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/api_key',
      builder: (context, state) => const ApiKeyScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/download',
      builder: (context, state) => const DownloadScreen(),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/detail',
      builder: (context, state) {
        if (state.extra is FoodItem) {
          final item = state.extra as FoodItem;
          return DetailScreen(item: item);
        } else if (state.extra is Map) {
          final extra = state.extra as Map<String, dynamic>;
          return DetailScreen(
            item: extra['item'] as FoodItem,
            onIngredientSelected: extra['onIngredientSelected'],
          );
        }
        return const Scaffold(body: Center(child: Text("Invalid Arguments")));
      },
    ),
  ],
);
