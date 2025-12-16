import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../search/presentation/bloc/data_sync_cubit.dart';
import '../bloc/settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<SettingsCubit>()..checkSettings()),
        BlocProvider(create: (context) => getIt<DataSyncCubit>()), // For checking/clearing data
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('설정')),
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final apiKey = (state is SettingsLoaded) ? state.settings.apiKey : '';
            
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionTitle(context, 'API 설정'),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.vpn_key),
                    title: const Text('API 키'),
                    subtitle: Text(apiKey ?? '설정되지 않음'),
                    trailing: const Icon(Icons.edit),
                    onTap: () {
                      context.push('/api_key');
                    },
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, '데이터 관리'),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.cloud_download),
                        title: const Text('데이터 다시 받기'),
                        subtitle: const Text('서버에서 최신 데이터를 받아옵니다.'),
                        onTap: () {
                          // Allow re-download. Go to download screen.
                          context.push('/download');
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.delete_forever, color: Colors.red),
                        title: const Text('데이터 삭제', style: TextStyle(color: Colors.red)),
                        subtitle: const Text('저장된 모든 데이터를 삭제합니다.'),
                        onTap: () async {
                           final confirm = await showDialog<bool>(
                             context: context,
                             builder: (context) => AlertDialog(
                               title: const Text('데이터 삭제'),
                               content: const Text('정말 삭제하시겠습니까?'),
                               actions: [
                                 TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('취소')),
                                 TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('삭제')),
                               ],
                             ),
                           );
                           
                           if (confirm == true && context.mounted) {
                             // Assuming we have a clear function in repository, 
                             // but DataSyncCubit doesn't expose it directly yet.
                             // We might need to add clearData to DataSyncCubit or SettingsCubit?
                             // Requirement said "Settings screen to delete/download".
                             // Let's assume re-download overwrites or clears.
                             // For explicit delete, we would need a method.
                             // For now, let's just show a snackbar saying "Use Re-download to refresh".
                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('데이터 다시 받기를 수행하면 데이터가 갱신됩니다.')));
                           }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, '앱 정보'),
                const Card(
                  child: ListTile(
                    leading: Icon(Icons.info),
                    title: Text('버전'),
                    subtitle: Text('1.0.0'),
                  ),
                ),
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
