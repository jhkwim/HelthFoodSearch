part of 'data_sync_cubit.dart';

abstract class DataSyncState extends Equatable {
  const DataSyncState();
  @override
  List<Object> get props => [];
}

class DataSyncInitial extends DataSyncState {}

class DataSyncLoading extends DataSyncState {}

class DataSyncNeeded extends DataSyncState {}

class DataSyncInProgress extends DataSyncState {
  final double progress;
  const DataSyncInProgress(this.progress);
  @override
  List<Object> get props => [progress];
}

class DataSyncSuccess extends DataSyncState {
  final StorageInfo? storageInfo;
  final bool updateNeeded;
  const DataSyncSuccess({this.storageInfo, this.updateNeeded = false});
  @override
  List<Object> get props => [if (storageInfo != null) storageInfo!, updateNeeded];
}

class DataSyncError extends DataSyncState {
  final String message;
  const DataSyncError(this.message);
  @override
  List<Object> get props => [message];
}
