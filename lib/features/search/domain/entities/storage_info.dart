import 'package:equatable/equatable.dart';

class StorageInfo extends Equatable {
  final int count;
  final int sizeBytes;

  const StorageInfo({
    required this.count, // -1 means unknown
    required this.sizeBytes, // -1 means unknown
  });

  @override
  List<Object?> get props => [count, sizeBytes];
}
