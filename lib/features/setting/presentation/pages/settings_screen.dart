import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:health_food_search/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:health_food_search/features/search/presentation/bloc/data_sync_cubit.dart';
import 'package:intl/intl.dart';
import '../bloc/settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
        appBar: AppBar(title: Text(l10n.settingsTitle)),
        body: BlocListener<SettingsCubit, SettingsState>(
          listener: (context, state) {
             if (state is SettingsLoaded) {
                // Handle Progress Dialog
                if (state.refinementProgress != null) {
                  // Show dialog if not already shown (check barrier? hard to check)
                  // Simplest way: check if we are already showing?
                  // Better: The dialog itself subscribes. 
                  // But how to trigger show?
                  // Trigger show when progress goes from null to non-null.
                  // But we don't have previous state here easily without listenWhen or distinct.
                  // Just show it. Use a flag in State? 
                  // Let's assume progress start = 0.0.
                  if (state.refinementProgress == 0.0) {
                     showDialog(
                       context: context,
                       barrierDismissible: false,
                       builder: (_) => PopScope(
                         canPop: false,
                         child: AlertDialog(
                           title: const Text('원재료 정제 중'),
                           content: BlocBuilder<SettingsCubit, SettingsState>(
                              builder: (context, dialogState) {
                                double p = 0;
                                if (dialogState is SettingsLoaded && dialogState.refinementProgress != null) {
                                   p = dialogState.refinementProgress!;
                                }
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                     LinearProgressIndicator(value: p),
                                     const SizedBox(height: 10),
                                     Text('${(p * 100).toInt()}%'),
                                  ],
                                );
                              }
                           ),
                         ),
                       ),
                     );
                  }
                } else {
                  // If progress is null, ensure dialog is closed.
                  // This is tricky if we don't know if it's open.
                  // Can use Navigator.of(context).pop() if we know we opened it.
                  // A naive way: rely on the fact that 0.0 triggers open, and completion triggers close.
                  // We need a way to know if we are the ones who opened it.
                  // Or, just use a "Processing" overlay in the body stack instead of Dialog. Reference: "Stack overlay" is much robust.
                  // But user wants "background processing" which usually implies non-blocking UI or at least minimal blocking.
                  // Let's go with the Listener-pop approach check. 
                  // If we just finished (null), pop. 
                  // But listener fires for every progress update.
                  // We need 'listenWhen'.
                }
             }
          },
          child: BlocConsumer<SettingsCubit, SettingsState>(
             listenWhen: (previous, current) {
                // Only listen for completion to pop
                final wasRefining = (previous is SettingsLoaded && previous.refinementProgress != null);
                final isRefining = (current is SettingsLoaded && current.refinementProgress != null);
                return wasRefining && !isRefining;
             },
             listener: (context, state) {
                Navigator.of(context).pop(); // Close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('원재료 재정제가 완료되었습니다.')),
                );
             },
             builder: (context, state) {
            final apiKey = (state is SettingsLoaded) ? state.settings.apiKey : '';
            final isLargeText = (state is SettingsLoaded) ? state.settings.textScale > 1.0 : false;
            final appVersion = (state is SettingsLoaded) ? state.appVersion : '';
            final themeMode = (state is SettingsLoaded) ? state.settings.themeMode : ThemeMode.system;
            
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionTitle(context, l10n.settingsDisplaySection),
// ... (I only need to replace the variable extraction and the Text widget at the bottom, but replace_file_content works on contiguous blocks. I should do 2 replacements if they are far apart)
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.brightness_6),
                        title: const Text('앱 테마'),
                        subtitle: Text(
                          themeMode == ThemeMode.system ? '시스템 설정' :
                          themeMode == ThemeMode.light ? '라이트 모드' : '다크 모드'
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('테마 선택'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile<ThemeMode>(
                                    title: const Text('시스템 설정'),
                                    value: ThemeMode.system,
                                    groupValue: themeMode,
                                    onChanged: (value) {
                                      if (value != null) {
                                        context.read<SettingsCubit>().saveThemeMode(value);
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                  RadioListTile<ThemeMode>(
                                    title: const Text('라이트 모드'),
                                    value: ThemeMode.light,
                                    groupValue: themeMode,
                                    onChanged: (value) {
                                      if (value != null) {
                                        context.read<SettingsCubit>().saveThemeMode(value);
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                  RadioListTile<ThemeMode>(
                                    title: const Text('다크 모드'),
                                    value: ThemeMode.dark,
                                    groupValue: themeMode,
                                    onChanged: (value) {
                                      if (value != null) {
                                        context.read<SettingsCubit>().saveThemeMode(value);
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        secondary: const Icon(Icons.format_size),
                        title: Text(l10n.settingsLargeText),
                        subtitle: Text(l10n.settingsLargeTextDesc),
                        value: isLargeText,
                        onChanged: (value) {
                          context.read<SettingsCubit>().toggleLargeText(value);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, l10n.settingsApiSection),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.vpn_key),
                    title: Text(l10n.settingsApiKey),
                    subtitle: Text(apiKey ?? l10n.settingsNotSet),
                    trailing: const Icon(Icons.edit),
                    onTap: () {
                      context.push('/api_key');
                    },
                  ),
                ),
                const SizedBox(height: 24),
                const SizedBox(height: 24),
                _buildSectionTitle(context, l10n.settingsDataSection),
                Card(
                  child: BlocBuilder<DataSyncCubit, DataSyncState>(
                    builder: (context, dataState) {
                      String subTitle = l10n.settingsDataRefreshDesc;
                      if (dataState is DataSyncSuccess && dataState.storageInfo != null) {
                        final info = dataState.storageInfo!;
                        final countStr = NumberFormat('#,###').format(info.count);
                        
                        if (info.sizeBytes > 0) {
                          final mb = (info.sizeBytes / (1024 * 1024)).toStringAsFixed(1);
                          subTitle = l10n.settingsDataSavedWithSize(countStr, mb);
                        } else {
                          subTitle = l10n.settingsDataSaved(countStr);
                        }
                      }

                      return Column(
                        children: [
                          if (state is SettingsLoaded)
                            Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.timer_outlined),
                                  title: const Text('업데이트 안내 주기'),
                                  subtitle: const Text('데이터 업데이트 필요 여부를 체크하는 주기입니다.'),
                                  trailing: DropdownButton<int>(
                                    value: state.settings.updateIntervalDays,
                                    onChanged: (int? newValue) {
                                      if (newValue != null) {
                                        context.read<SettingsCubit>().saveUpdateInterval(newValue);
                                      }
                                    },
                                    underline: Container(),
                                    items: const [
                                      DropdownMenuItem(value: 15, child: Text('15일')),
                                      DropdownMenuItem(value: 30, child: Text('30일')),
                                      DropdownMenuItem(value: 45, child: Text('45일')),
                                      DropdownMenuItem(value: 60, child: Text('60일')),
                                      DropdownMenuItem(value: 90, child: Text('90일')),
                                    ],
                                  ),
                                ),
                                const Divider(),
                              ],
                            ),
                          ListTile(
                            leading: const Icon(Icons.cloud_download),
                            title: Text(l10n.settingsDataRefresh),
                            subtitle: Text(subTitle),
                            onTap: () {
                              context.push('/download');
                            },
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.refresh, color: Colors.blue),
                            title: const Text('데이터 재정제 (고급)'),
                            subtitle: const Text('최신 규칙으로 원재료명을 다시 정리합니다.'),
                            onTap: () {
                              context.read<SettingsCubit>().refineData();
                            },
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.file_download),
                            title: const Text('데이터 엑셀 내보내기'), // TODO: Localization
                            subtitle: const Text('저장된 식품 정보를 엑셀 파일로 저장하거나 공유합니다.'),
                            onTap: () {
                              // Trigger export
                              context.read<SettingsCubit>().exportData();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('엑셀 파일 생성 중...')),
                              );
                            },
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.delete_forever, color: Colors.red),
                            title: Text(l10n.settingsDataDelete, style: const TextStyle(color: Colors.red)),
                            subtitle: Text(l10n.settingsDataDeleteDesc),
                            onTap: () async {
                               final confirm = await showDialog<bool>(
                                 context: context,
                                 builder: (context) => AlertDialog(
                                   title: Text(l10n.settingsDataDeleteConfirmTitle),
                                   content: Text(l10n.settingsDataDeleteConfirmContent),
                                   actions: [
                                     TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.settingsDataDeleteCancel)),
                                     TextButton(onPressed: () => Navigator.pop(context, true), child: Text(l10n.settingsDataDeleteConfirm)),
                                   ],
                                 ),
                               );
                               
                               if (confirm == true && context.mounted) {
                                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.settingsDataRefreshNotice)));
                                 // Ideally trigger clear here via DataSyncCubit (missing clear method exposure?)
                                 // DataSyncCubit only has syncData. 
                                 // Ideally we should add clearData to DataSyncCubit too. But user didn't ask explicitly.
                                 // The current code just shows snackbar. I will leave it as is.
                               }
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, l10n.settingsAppInfoSection),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.info),
                    title: Text(l10n.settingsVersion),
                    subtitle: Text(appVersion.isEmpty ? l10n.settingsLoading : appVersion),
                  ),
                ),
                
                const SizedBox(height: 24),
                if (!kReleaseMode) ...[ 
                  _buildSectionTitle(context, '개발자 도구 (테스트용)'),
                  Card(
                    color: Colors.red[50],
                    child: ListTile(
                      leading: const Icon(Icons.bug_report, color: Colors.red),
                      title: const Text('강제 업데이트 만료 처리'),
                      subtitle: const Text('마지막 업데이트 시간을 30일 전으로 되돌립니다.\n앱 재시작 시 업데이트 팝업을 테스트할 수 있습니다.'),
                      onTap: () async {
                         await context.read<SettingsCubit>().forceExpireSyncTime();
                         if (context.mounted) {
                           ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(content: Text('업데이트 시간이 만료되었습니다. 앱을 재시작하세요.')),
                           );
                         }
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ],
            );
          }),
        ),
      );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
