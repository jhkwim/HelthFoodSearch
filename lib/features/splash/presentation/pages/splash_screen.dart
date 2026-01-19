import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:health_food_search/features/setting/presentation/bloc/settings_cubit.dart';
import 'package:health_food_search/features/search/presentation/bloc/data_sync_cubit.dart';
import 'package:health_food_search/l10n/app_localizations.dart';

import '../../../../core/extensions/failure_extension.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isUpdateDialogShown = false;

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
    final l10n = AppLocalizations.of(context)!;
    // Removed MultiBlocProvider as Cubits are provided in main.dart
    return MultiBlocListener(
      listeners: [
        BlocListener<SettingsCubit, SettingsState>(
          listener: (context, state) {
            if (state is SettingsLoaded) {
              _handleSettingsLoaded(state);
            } else if (state is SettingsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Settings Error: ${state.failure.toUserMessage(context)}',
                  ),
                ),
              );
            }
          },
        ),
        BlocListener<DataSyncCubit, DataSyncState>(
          listener: (context, state) {
            debugPrint('[SplashScreen] DataSyncCubit Listener: $state');
            if (state is DataSyncSuccess) {
              if (state.updateNeeded) {
                if (!_isUpdateDialogShown) {
                  _isUpdateDialogShown = true;
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      title: Text(l10n.updateNeededTitle),
                      content: Text(l10n.updateNeededContent),
                      actions: [
                        TextButton(
                          onPressed: () {
                            _isUpdateDialogShown = false;
                            Navigator.of(context).pop();
                            context.go('/main');
                          },
                          child: Text(l10n.updateLater),
                        ),
                        TextButton(
                          onPressed: () {
                            _isUpdateDialogShown = false;
                            Navigator.of(context).pop();
                            context.go('/download');
                          },
                          child: Text(l10n.updateNow),
                        ),
                      ],
                    ),
                  );
                }
              } else {
                context.go('/main');
              }
            } else if (state is DataSyncNeeded) {
              context.go('/download');
            } else if (state is DataSyncError) {
              // Web 등에서 초기화 에러 발생 시, 스낵바만 띄우면 화면이 멈춘 것처럼 보임.
              // 다이얼로그를 띄워서 사용자가 이동할 수 있게 해야 함.
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  title: const Text('데이터 확인 오류'), // L10n 적용을 위해 추후 작업 필요
                  content: Text(
                    '데이터를 확인하는 중 문제가 발생했습니다.\n(${state.failure.toUserMessage(context)})\n\n다운로드 화면으로 이동하여 복구를 시도하시겠습니까?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // 메인으로 강제 이동 (오프라인 모드 시도)
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
                      child: const Text('복구(다운로드)'),
                    ),
                  ],
                ),
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
                style: Theme.of(
                  context,
                ).textTheme.displayMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
