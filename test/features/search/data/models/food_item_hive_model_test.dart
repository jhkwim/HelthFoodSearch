import 'package:flutter_test/flutter_test.dart';
import 'package:health_food_search/features/search/data/models/food_item_hive_model.dart';
import 'package:health_food_search/features/search/domain/entities/food_item.dart';

void main() {
  const tFoodItem = FoodItem(
    reportNo: '200400200075',
    prdlstNm: '관절팔팔',
    rawmtrlNm: '원재료명',
    mainIngredients: ['초록입홍합추출오일복합물'],
    bsshNm: '(주) 씨스팡',
    prmsDt: '2024-01-01',
    primaryFnclty: '주된기능성',
    pogDaycnt: '제조일로부터 3년',
    dispos: '캡슐',
    ntkMthd: '1일 2회',
    iftknAtntMatrCn: '주의사항',
    stdrStnd: '기준규격',
    cstdyMthd: '보관방법',
  );

  group('FoodItemHiveModel', () {
    test('should convert valid Entity to HiveModel', () {
      final model = FoodItemHiveModel.fromEntity(tFoodItem);
      
      expect(model.reportNo, tFoodItem.reportNo);
      expect(model.prdlstNm, tFoodItem.prdlstNm);
      expect(model.mainIngredients, tFoodItem.mainIngredients);
      expect(model.pogDaycnt, tFoodItem.pogDaycnt);
    });

    test('should convert HiveModel back to Entity', () {
      final model = FoodItemHiveModel.fromEntity(tFoodItem);
      final result = model.toEntity();
      
      expect(result, tFoodItem);
    });
  });
}
