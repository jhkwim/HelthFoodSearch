// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodItemDto _$FoodItemDtoFromJson(Map<String, dynamic> json) => FoodItemDto(
      reportNo: json['PRDLST_REPORT_NO'] as String,
      prdlstNm: json['PRDLST_NM'] as String,
      rawmtrlNm: json['RAWMTRL_NM'] as String,
      bsshNm: json['BSSH_NM'] as String,
      prmsDt: json['PRMS_DT'] as String,
    );

Map<String, dynamic> _$FoodItemDtoToJson(FoodItemDto instance) =>
    <String, dynamic>{
      'PRDLST_REPORT_NO': instance.reportNo,
      'PRDLST_NM': instance.prdlstNm,
      'RAWMTRL_NM': instance.rawmtrlNm,
      'BSSH_NM': instance.bsshNm,
      'PRMS_DT': instance.prmsDt,
    };
