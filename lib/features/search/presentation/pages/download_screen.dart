import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../bloc/data_sync_cubit.dart';

class DownloadScreen extends StatelessWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DataSyncCubit>(), // Do not checkData automatically here, triggered by button or internal logic
      child: BlocConsumer<DataSyncCubit, DataSyncState>(
        listener: (context, state) {
          if (state is DataSyncSuccess) {
            context.go('/main');
          } else if (state is DataSyncError) {
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('데이터 다운로드')),
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_download, size: 80, color: Colors.grey),
                  const SizedBox(height: 24),
                  Text(
                    '최신 데이터를 받아옵니다.',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '데이터가 많아 시간이 소요될 수 있습니다.\n와이파이 환경을 권장합니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 48),
                  if (state is DataSyncInProgress) ...[
                    LinearProgressIndicator(value: state.progress),
                    const SizedBox(height: 16),
                    Text('${(state.progress * 100).toInt()}% 완료'),
                  ] else ...[
                    ElevatedButton(
                      onPressed: () {
                        context.read<DataSyncCubit>().syncData();
                      },
                      child: const Text('다운로드 시작'),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
