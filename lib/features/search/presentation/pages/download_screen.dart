import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/data_sync_cubit.dart';
import 'package:health_food_search/l10n/app_localizations.dart';

import '../../../../core/extensions/failure_extension.dart';

class DownloadScreen extends StatelessWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocConsumer<DataSyncCubit, DataSyncState>(
      listener: (context, state) {
        if (state is DataSyncSuccess) {
          // Only navigate if we are currently on this screen?
          // Since this is a global listener now (if we leave it here), careful.
          // Wait, this listener is attached to the widget. If widget is disposed (popped), listener stops.
          // That is fine. If user goes to background, this screen is popped, so this listener dies. MainScreen handles success?
          // User request: "Download continues... show progress on Search Screen".
          // So MainScreen needs to listen or show status.

          // Use go() might be abrupt if user is just watching. 'go' is fine.
          // Only navigate if update is NOT needed (meaning sync completed or fresh start)
          // If updateNeeded is true, it means we are here to download, so stay here.
          if (!state.updateNeeded) {
            if (GoRouter.of(
                  context,
                ).routerDelegate.currentConfiguration.fullPath ==
                '/download') {
              context.go('/main');
            }
          }
        } else if (state is DataSyncError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.failure.toUserMessage(context))),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(l10n.downloadTitle)),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.cloud_download,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.downloadingTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.downloadingDesc,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 48),
                  if (state is DataSyncInProgress) ...[
                    LinearProgressIndicator(
                      value: state.progress.clamp(0.0, 1.0),
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(height: 16),
                    Text(
                      l10n.downloadCompletePercent(
                        (state.progress * 100).clamp(0, 100).toInt(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () {
                        context.go('/main');
                      },
                      child: Text(l10n.downloadRunInBackground),
                    ),
                  ] else ...[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 32,
                        ),
                      ),
                      onPressed: () {
                        context.read<DataSyncCubit>().syncData();
                      },
                      child: Text(l10n.downloadStart),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
