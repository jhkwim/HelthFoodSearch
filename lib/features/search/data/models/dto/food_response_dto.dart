import 'package:json_annotation/json_annotation.dart';
import 'food_item_dto.dart';

part 'food_response_dto.g.dart';

@JsonSerializable()
class FoodResponseDto {
  @JsonKey(name: 'I0030')
  final I0030Dto? data;

  FoodResponseDto({this.data});

  factory FoodResponseDto.fromJson(Map<String, dynamic> json) => _$FoodResponseDtoFromJson(json);
}

@JsonSerializable()
class I0030Dto {
  @JsonKey(name: 'total_count')
  final String totalCount;
  @JsonKey(name: 'row')
  final List<FoodItemDto>? row;
  @JsonKey(name: 'RESULT')
  final ResultDto? result;

  I0030Dto({required this.totalCount, this.row, this.result});

  factory I0030Dto.fromJson(Map<String, dynamic> json) => _$I0030DtoFromJson(json);
}

@JsonSerializable()
class ResultDto {
  @JsonKey(name: 'MSG')
  final String msg;
  @JsonKey(name: 'CODE')
  final String code;

  ResultDto({required this.msg, required this.code});

  factory ResultDto.fromJson(Map<String, dynamic> json) => _$ResultDtoFromJson(json);
}
