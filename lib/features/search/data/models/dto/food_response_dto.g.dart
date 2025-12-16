// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodResponseDto _$FoodResponseDtoFromJson(Map<String, dynamic> json) =>
    FoodResponseDto(
      data: json['I0030'] == null
          ? null
          : I0030Dto.fromJson(json['I0030'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FoodResponseDtoToJson(FoodResponseDto instance) =>
    <String, dynamic>{
      'I0030': instance.data,
    };

I0030Dto _$I0030DtoFromJson(Map<String, dynamic> json) => I0030Dto(
      totalCount: json['total_count'] as String,
      row: (json['row'] as List<dynamic>?)
          ?.map((e) => FoodItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      result: json['RESULT'] == null
          ? null
          : ResultDto.fromJson(json['RESULT'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$I0030DtoToJson(I0030Dto instance) => <String, dynamic>{
      'total_count': instance.totalCount,
      'row': instance.row,
      'RESULT': instance.result,
    };

ResultDto _$ResultDtoFromJson(Map<String, dynamic> json) => ResultDto(
      msg: json['MSG'] as String,
      code: json['CODE'] as String,
    );

Map<String, dynamic> _$ResultDtoToJson(ResultDto instance) => <String, dynamic>{
      'MSG': instance.msg,
      'CODE': instance.code,
    };
