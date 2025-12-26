import 'package:hive/hive.dart';

part 'search_history_hive_model.g.dart';

@HiveType(typeId: 4)
class SearchHistoryHiveModel extends HiveObject {
  @HiveField(0)
  final String query;

  @HiveField(1)
  final String type; // 'product' | 'ingredient'

  @HiveField(2)
  final DateTime searchedAt;

  SearchHistoryHiveModel({
    required this.query,
    required this.type,
    required this.searchedAt,
  });
}
