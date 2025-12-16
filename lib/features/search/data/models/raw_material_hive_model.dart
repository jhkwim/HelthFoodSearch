import 'package:hive/hive.dart';

part 'raw_material_hive_model.g.dart';

@HiveType(typeId: 1)
class RawMaterialHiveModel extends HiveObject {
  @HiveField(0)
  final String reportNo;
  @HiveField(1)
  @HiveField(1)
  final List<String> rawMtrlNms;

  RawMaterialHiveModel({
    required this.reportNo,
    required this.rawMtrlNms,
  });
}
