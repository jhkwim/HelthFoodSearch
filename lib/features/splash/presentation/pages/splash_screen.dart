import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:health_food_search/features/setting/presentation/bloc/settings_cubit.dart';
import 'package:health_food_search/features/search/presentation/bloc/data_sync_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Check initial state after first frame to avoid "Setstate during build" or Context issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkInitialState();
    });
  }

  void _checkInitialState() {
    if (!mounted) return;
    final settingsState = context.read<SettingsCubit>().state;
    if (settingsState is SettingsLoaded) {
      _handleSettingsLoaded(settingsState);
    }
  }

  void _handleSettingsLoaded(SettingsLoaded state) {
     if (state.isApiKeyMissing) {
        context.go('/api_key');
      } else {
        context.read<DataSyncCubit>().checkData();
      }
  }

  @override
  Widget build(BuildContext context) {
    // Removed MultiBlocProvider as Cubits are provided in main.dart
    return MultiBlocListener(
      listeners: [
        BlocListener<SettingsCubit, SettingsState>(
          listener: (context, state) {
            if (state is SettingsLoaded) {
              _handleSettingsLoaded(state);
            } else if (state is SettingsError) {
               ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Settings Error: ${state.message}')),
              );
            }
          },
        ),
        BlocListener<DataSyncCubit, DataSyncState>(
          listener: (context, state) {
            if (state is DataSyncSuccess) {
              if (state.updateNeeded) {
                 showDialog(
                   context: context,
                   barrierDismissible: false,
                   builder: (context) => AlertDialog(
                     title: const Text('데이터 업데이트 필요'),
                     content: const Text('마지막 업데이트로부터 30일이 지났습니다.\n최신 데이터로 업데이트하시겠습니까?'),
                     actions: [
                       TextButton(
                         onPressed: () {
                           Navigator.of(context).pop();
                           context.go('/main');
                         },
                         child: const Text('나중에'),
                       ),
                       TextButton(
                         onPressed: () {
                           Navigator.of(context).pop();
                           context.go('/download');
                         },
                         child: const Text('업데이트'),
                       ),
                     ],
                   ),
                 );
              } else {
                context.go('/main');
              }
            } else if (state is DataSyncNeeded) {
              context.go('/download');
            } else if (state is DataSyncError) {
               ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Data Check Error: ${state.message}')),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.health_and_safety,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              Text(
                '건강기능식품 검색',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
