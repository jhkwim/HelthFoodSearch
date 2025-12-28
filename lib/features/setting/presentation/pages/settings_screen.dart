// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:health_food_search/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:health_food_search/features/search/presentation/bloc/data_sync_cubit.dart';
import 'package:intl/intl.dart';
import '../bloc/settings_cubit.dart';

import '../../../../core/extensions/failure_extension.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: MultiBlocListener(
        listeners: [
          BlocListener<SettingsCubit, SettingsState>(
            listener: (context, state) {
              if (state is SettingsLoaded) {
                // ... existing dialog logic ...
                if (state.refinementProgress != null) {
                  if (state.refinementProgress == 0.0) {
                    // show dialog logic
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => PopScope(
                        canPop: false,
                        child: AlertDialog(
                          title: Text(l10n.settingsRefiningTitle),
                          content: BlocBuilder<SettingsCubit, SettingsState>(
                            builder: (context, dialogState) {
                              double p = 0;
                              if (dialogState is SettingsLoaded &&
                                  dialogState.refinementProgress != null) {
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
                            },
                          ),
                        ),
                      ),
                    );
                  }
                }
              } else if (state is SettingsError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.failure.toUserMessage(context))),
                );
              }
            },
          ),
        ],
        child: BlocConsumer<SettingsCubit, SettingsState>(
          listenWhen: (previous, current) {
            // Only listen for completion to pop
            final wasRefining =
                (previous is SettingsLoaded &&
                previous.refinementProgress != null);
            final isRefining =
                (current is SettingsLoaded &&
                current.refinementProgress != null);
            return wasRefining && !isRefining;
          },
          listener: (context, state) {
            Navigator.of(context).pop(); // Close dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.settingsRefiningComplete)),
            );
          },
          builder: (context, state) {
            final apiKey = (state is SettingsLoaded)
                ? state.settings.apiKey
                : '';
            final isLargeText = (state is SettingsLoaded)
                ? state.settings.textScale > 1.0
                : false;
            final appVersion = (state is SettingsLoaded)
                ? state.appVersion
                : '';
            final themeMode = (state is SettingsLoaded)
                ? state.settings.themeMode
                : ThemeMode.system;

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
                        title: Text(l10n.settingsThemeTitle),
                        subtitle: Text(
                          themeMode == ThemeMode.system
                              ? l10n.settingsThemeSystem
                              : themeMode == ThemeMode.light
                              ? l10n.settingsThemeLight
                              : l10n.settingsThemeDark,
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(l10n.settingsThemeSelectTitle),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile<ThemeMode>(
                                    title: Text(l10n.settingsThemeSystem),
                                    value: ThemeMode.system,
                                    groupValue: themeMode,
                                    onChanged: (value) {
                                      if (value != null) {
                                        context
                                            .read<SettingsCubit>()
                                            .saveThemeMode(value);
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                  RadioListTile<ThemeMode>(
                                    title: Text(l10n.settingsThemeLight),
                                    value: ThemeMode.light,
                                    groupValue: themeMode,
                                    onChanged: (value) {
                                      if (value != null) {
                                        context
                                            .read<SettingsCubit>()
                                            .saveThemeMode(value);
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                  RadioListTile<ThemeMode>(
                                    title: Text(l10n.settingsThemeDark),
                                    value: ThemeMode.dark,
                                    groupValue: themeMode,
                                    onChanged: (value) {
                                      if (value != null) {
                                        context
                                            .read<SettingsCubit>()
                                            .saveThemeMode(value);
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
                      if (dataState is DataSyncSuccess &&
                          dataState.storageInfo != null) {
                        final info = dataState.storageInfo!;
                        final countStr = NumberFormat(
                          '#,###',
                        ).format(info.count);

                        if (info.sizeBytes > 0) {
                          final mb = (info.sizeBytes / (1024 * 1024))
                              .toStringAsFixed(1);
                          subTitle = l10n.settingsDataSavedWithSize(
                            countStr,
                            mb,
                          );
                        } else {
                          subTitle = l10n.settingsDataSaved(countStr);
                        }
                      }

                      if (state is SettingsLoaded &&
                          state.settings.lastSyncTime != null) {
                        final timeStr = DateFormat(
                          'yyyy-MM-dd HH:mm',
                        ).format(state.settings.lastSyncTime!);
                        subTitle += '\n${l10n.apiLastUpdate(timeStr)}';
                      }

                      return Column(
                        children: [
                          if (state is SettingsLoaded)
                            Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.timer_outlined),
                                  title: Text(l10n.settingsUpdateParamsTitle),
                                  subtitle: Text(l10n.settingsUpdateParamsDesc),
                                  trailing: DropdownButton<int>(
                                    value: state.settings.updateIntervalDays,
                                    onChanged: (int? newValue) {
                                      if (newValue != null) {
                                        context
                                            .read<SettingsCubit>()
                                            .saveUpdateInterval(newValue);
                                      }
                                    },
                                    underline: Container(),
                                    items: [
                                      DropdownMenuItem(
                                        value: 15,
                                        child: Text(
                                          l10n.updateIntervalDays(15),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 30,
                                        child: Text(
                                          l10n.updateIntervalDays(30),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 45,
                                        child: Text(
                                          l10n.updateIntervalDays(45),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 60,
                                        child: Text(
                                          l10n.updateIntervalDays(60),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 90,
                                        child: Text(
                                          l10n.updateIntervalDays(90),
                                        ),
                                      ),
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
                            isThreeLine: true,
                            onTap: () {
                              context.push('/download');
                            },
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(
                              Icons.refresh,
                              color: Colors.blue,
                            ),
                            title: Text(l10n.ruleUpdatesAndRefinement),
                            subtitle: Text(
                              (state is SettingsLoaded &&
                                      state.settings.lastRefinementUpdate !=
                                          null)
                                  ? l10n.ruleUpdatesDescWithTime(
                                      DateFormat('yyyy-MM-dd HH:mm').format(
                                        state.settings.lastRefinementUpdate!,
                                      ),
                                    )
                                  : l10n.ruleUpdatesDesc,
                            ),
                            isThreeLine: true,
                            onTap: () {
                              context.read<SettingsCubit>().refineData();
                            },
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.file_download),
                            title: Text(
                              l10n.settingsExportTitle,
                            ), // TODO: Localization
                            subtitle: Text(l10n.settingsExportDesc),
                            onTap: () {
                              // Trigger export
                              context.read<SettingsCubit>().exportData();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.settingsExporting)),
                              );
                            },
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                            ),
                            title: Text(
                              l10n.settingsDataDelete,
                              style: const TextStyle(color: Colors.red),
                            ),
                            subtitle: Text(l10n.settingsDataDeleteDesc),
                            onTap: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                    l10n.settingsDataDeleteConfirmTitle,
                                  ),
                                  content: Text(
                                    l10n.settingsDataDeleteConfirmContent,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: Text(
                                        l10n.settingsDataDeleteCancel,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: Text(
                                        l10n.settingsDataDeleteConfirm,
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      l10n.settingsDataRefreshNotice,
                                    ),
                                  ),
                                );
                                await context.read<DataSyncCubit>().clearData();
                                if (context.mounted) {
                                  context.push('/download');
                                }
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
                    subtitle: Text(
                      appVersion.isEmpty ? l10n.settingsLoading : appVersion,
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                if (!kReleaseMode) ...[
                  _buildSectionTitle(context, l10n.settingsDevToolsTitle),
                  Card(
                    color: Colors.red[50],
                    child: ListTile(
                      leading: const Icon(Icons.bug_report, color: Colors.red),
                      title: Text(l10n.settingsDevForceExpire),
                      subtitle: Text(l10n.settingsDevForceExpireDesc),
                      onTap: () async {
                        await context
                            .read<SettingsCubit>()
                            .forceExpireSyncTime();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.settingsDevForceExpireSuccess),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ],
            );
          },
        ),
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
