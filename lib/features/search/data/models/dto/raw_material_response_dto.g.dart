// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raw_material_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RawMaterialResponseDto _$RawMaterialResponseDtoFromJson(
        Map<String, dynamic> json) =>
    RawMaterialResponseDto(
      data: json['C003'] == null
          ? null
          : RawMaterialResult.fromJson(json['C003'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RawMaterialResponseDtoToJson(
        RawMaterialResponseDto instance) =>
    <String, dynamic>{
      'C003': instance.data,
    };

RawMaterialResult _$RawMaterialResultFromJson(Map<String, dynamic> json) =>
    RawMaterialResult(
      totalCount: json['total_count'] as String,
      row: (json['row'] as List<dynamic>?)
          ?.map((e) => RawMaterialDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RawMaterialResultToJson(RawMaterialResult instance) =>
    <String, dynamic>{
      'total_count': instance.totalCount,
      'row': instance.row,
    };

RawMaterialDto _$RawMaterialDtoFromJson(Map<String, dynamic> json) =>
    RawMaterialDto(
      reportNo: json['PRDLST_REPORT_NO'] as String,
      rawMtrlNm: json['RAWMTRL_NM'] as String,
    );

Map<String, dynamic> _$RawMaterialDtoToJson(RawMaterialDto instance) =>
    <String, dynamic>{
      'PRDLST_REPORT_NO': instance.reportNo,
      'RAWMTRL_NM': instance.rawMtrlNm,
    };
