import 'package:hive/hive.dart';

part 'favorite_hive_model.g.dart';

@HiveType(typeId: 3)
class FavoriteHiveModel extends HiveObject {
  @HiveField(0)
  final String reportNo;

  @HiveField(1)
  final String prdlstNm;

  @HiveField(2)
  final DateTime addedAt;

  FavoriteHiveModel({
    required this.reportNo,
    required this.prdlstNm,
    required this.addedAt,
  });
}
