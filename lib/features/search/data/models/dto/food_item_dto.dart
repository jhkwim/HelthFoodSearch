import 'package:json_annotation/json_annotation.dart';
import '../../../../search/domain/entities/food_item.dart';

part 'food_item_dto.g.dart';

@JsonSerializable()
class FoodItemDto {
  @JsonKey(name: 'PRDLST_REPORT_NO')
  final String reportNo;
  @JsonKey(name: 'PRDLST_NM')
  final String prdlstNm;
  @JsonKey(name: 'RAWMTRL_NM')
  final String rawmtrlNm;
  @JsonKey(name: 'BSSH_NM')
  final String bsshNm;
  @JsonKey(name: 'PRMS_DT')
  final String prmsDt;

  FoodItemDto({
    required this.reportNo,
    required this.prdlstNm,
    required this.rawmtrlNm,
    required this.bsshNm,
    required this.prmsDt,
  });

  factory FoodItemDto.fromJson(Map<String, dynamic> json) => _$FoodItemDtoFromJson(json);
  Map<String, dynamic> toJson() => _$FoodItemDtoToJson(this);

  FoodItem toEntity() {
    // Basic ingredient splitting, will be refined later
    final ingredients = rawmtrlNm.split(',').map((e) => e.trim()).toList();
    return FoodItem(
      reportNo: reportNo,
      prdlstNm: prdlstNm,
      rawmtrlNm: rawmtrlNm,
      mainIngredients: ingredients,
      bsshNm: bsshNm,
      prmsDt: prmsDt,
    );
  }
}
