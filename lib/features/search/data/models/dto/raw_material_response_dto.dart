import 'package:json_annotation/json_annotation.dart';

part 'raw_material_response_dto.g.dart';

@JsonSerializable()
class RawMaterialResponseDto {
  @JsonKey(name: 'C003')
  final RawMaterialResult? data;

  RawMaterialResponseDto({this.data});

  factory RawMaterialResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RawMaterialResponseDtoFromJson(json);
}

@JsonSerializable()
class RawMaterialResult {
  @JsonKey(name: 'total_count')
  final String totalCount;
  @JsonKey(name: 'row')
  final List<RawMaterialDto>? row;

  RawMaterialResult({required this.totalCount, this.row});

  factory RawMaterialResult.fromJson(Map<String, dynamic> json) =>
      _$RawMaterialResultFromJson(json);
}

@JsonSerializable()
class RawMaterialDto {
  @JsonKey(name: 'PRDLST_REPORT_NO')
  final String reportNo;
  @JsonKey(name: 'RAWMTRL_NM')
  final String rawMtrlNm;

  RawMaterialDto({
    required this.reportNo,
    required this.rawMtrlNm,
  });

  factory RawMaterialDto.fromJson(Map<String, dynamic> json) =>
      _$RawMaterialDtoFromJson(json);
}
