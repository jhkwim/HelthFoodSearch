import 'package:hive/hive.dart';
import '../../../../search/domain/entities/food_item.dart';

part 'food_item_hive_model.g.dart';

@HiveType(typeId: 0)
class FoodItemHiveModel extends HiveObject {
  @HiveField(0)
  final String reportNo;
  @HiveField(1)
  final String prdlstNm;
  @HiveField(2)
  final String rawmtrlNm;
  @HiveField(3)
  final List<String> mainIngredients;
  @HiveField(4)
  final String bsshNm;
  @HiveField(5)
  final String prmsDt;

  FoodItemHiveModel({
    required this.reportNo,
    required this.prdlstNm,
    required this.rawmtrlNm,
    required this.mainIngredients,
    required this.bsshNm,
    required this.prmsDt,
  });

  factory FoodItemHiveModel.fromEntity(FoodItem item) {
    return FoodItemHiveModel(
      reportNo: item.reportNo,
      prdlstNm: item.prdlstNm,
      rawmtrlNm: item.rawmtrlNm,
      mainIngredients: item.mainIngredients,
      bsshNm: item.bsshNm,
      prmsDt: item.prmsDt,
    );
  }

  FoodItem toEntity() {
    return FoodItem(
      reportNo: reportNo,
      prdlstNm: prdlstNm,
      rawmtrlNm: rawmtrlNm,
      mainIngredients: mainIngredients,
      bsshNm: bsshNm,
      prmsDt: prmsDt,
    );
  }
}
