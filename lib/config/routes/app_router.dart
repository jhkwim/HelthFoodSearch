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
        final item = state.extra as FoodItem;
        return DetailScreen(item: item);
      },
    ),
  ],
);
