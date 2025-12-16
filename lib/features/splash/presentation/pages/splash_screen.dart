import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../setting/presentation/bloc/settings_cubit.dart';
import '../../search/presentation/bloc/data_sync_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<SettingsCubit>()..checkSettings()),
        BlocProvider(create: (context) => getIt<DataSyncCubit>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<SettingsCubit, SettingsState>(
            listener: (context, state) {
              if (state is SettingsLoaded) {
                if (state.isApiKeyMissing) {
                  context.go('/api_key');
                } else {
                  // Check data existence if API key is present
                  context.read<DataSyncCubit>().checkData();
                }
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
                // Has data
                context.go('/main');
              } else if (state is DataSyncNeeded) {
                // No data
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
      ),
    );
  }
}
