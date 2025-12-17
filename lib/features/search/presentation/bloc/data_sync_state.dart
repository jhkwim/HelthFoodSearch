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
  const DataSyncSuccess({this.storageInfo});
  @override
  List<Object> get props => [if (storageInfo != null) storageInfo!];
}

class DataSyncError extends DataSyncState {
  final String message;
  const DataSyncError(this.message);
  @override
  List<Object> get props => [message];
}
