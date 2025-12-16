import 'package:json_annotation/json_annotation.dart';
import '../../../../search/domain/entities/food_item.dart';
import 'package:health_food_search/core/utils/ingredient_refiner.dart';

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

  @JsonKey(name: 'PRIMARY_FNCLTY', defaultValue: '')
  final String primaryFnclty;
  @JsonKey(name: 'IFTKN_ATNT_MATR_CN', defaultValue: '')
  final String iftknAtntMatrCn;
  @JsonKey(name: 'NTK_MTHD', defaultValue: '')
  final String ntkMthd;
  @JsonKey(name: 'CSTDY_MTHD', defaultValue: '')
  final String cstdyMthd;
  @JsonKey(name: 'POG_DAYCNT', defaultValue: '')
  final String pogDaycnt;
  @JsonKey(name: 'DISPOS', defaultValue: '')
  final String dispos;

  @JsonKey(name: 'LCNS_NO', defaultValue: '')
  final String lcnsNo;
  @JsonKey(name: 'PRDLST_CDNM', defaultValue: '')
  final String prdlstCdnm;
  @JsonKey(name: 'STDR_STND', defaultValue: '')
  final String stdrStnd;
  @JsonKey(name: 'HIENG_LNTRT_DVS_NM', defaultValue: '')
  final String hiengLntrtDvsNm;
  @JsonKey(name: 'PRODUCTION', defaultValue: '')
  final String production;
  @JsonKey(name: 'CHILD_CRTFC_YN', defaultValue: '')
  final String childCrtfcYn;
  @JsonKey(name: 'PRDT_SHAP_CD_NM', defaultValue: '')
  final String prdtShapCdNm;
  @JsonKey(name: 'FRMLC_MTRQLT', defaultValue: '')
  final String frmlcMtrqlt;
  @JsonKey(name: 'INDUTY_CD_NM', defaultValue: '')
  final String indutyCdNm;
  @JsonKey(name: 'LAST_UPDT_DTM', defaultValue: '')
  final String lastUpdtDtm;
  @JsonKey(name: 'INDIV_RAWMTRL_NM', defaultValue: '')
  final String indivRawmtrlNm;
  @JsonKey(name: 'ETC_RAWMTRL_NM', defaultValue: '')
  final String etcRawmtrlNm;
  @JsonKey(name: 'CAP_RAWMTRL_NM', defaultValue: '')
  final String capRawmtrlNm;
  @JsonKey(name: 'FRMLC_MTHD', defaultValue: '')
  final String frmlcMthd;

  FoodItemDto({
    required this.reportNo,
    required this.prdlstNm,
    required this.rawmtrlNm,
    required this.bsshNm,
    required this.prmsDt,
    this.primaryFnclty = '',
    this.iftknAtntMatrCn = '',
    this.ntkMthd = '',
    this.cstdyMthd = '',
    this.pogDaycnt = '',
    this.dispos = '',
    this.lcnsNo = '',
    this.prdlstCdnm = '',
    this.stdrStnd = '',
    this.hiengLntrtDvsNm = '',
    this.production = '',
    this.childCrtfcYn = '',
    this.prdtShapCdNm = '',
    this.frmlcMtrqlt = '',
    this.indutyCdNm = '',
    this.lastUpdtDtm = '',
    this.indivRawmtrlNm = '',
    this.etcRawmtrlNm = '',
    this.capRawmtrlNm = '',
    this.frmlcMthd = '',
  });

  factory FoodItemDto.fromJson(Map<String, dynamic> json) => _$FoodItemDtoFromJson(json);
  Map<String, dynamic> toJson() => _$FoodItemDtoToJson(this);

  FoodItem toEntity() {
    // Use IngredientRefiner to clean up ingredient names
    // Prioritize INDIV_RAWMTRL_NM if available for refinement, or sticking to RAWMTRL_NM as base?
    // User wants "Functional Ingredients" at the bottom. RAWMTRL_NM is general.
    final ingredients = IngredientRefiner.refineAll(rawmtrlNm);
    return FoodItem(
      reportNo: reportNo,
      prdlstNm: prdlstNm,
      rawmtrlNm: rawmtrlNm,
      mainIngredients: ingredients,
      bsshNm: bsshNm,
      prmsDt: prmsDt,
      primaryFnclty: primaryFnclty,
      iftknAtntMatrCn: iftknAtntMatrCn,
      ntkMthd: ntkMthd,
      cstdyMthd: cstdyMthd,
      pogDaycnt: pogDaycnt,
      dispos: dispos,
      lcnsNo: lcnsNo,
      prdlstCdnm: prdlstCdnm,
      stdrStnd: stdrStnd,
      hiengLntrtDvsNm: hiengLntrtDvsNm,
      production: production,
      childCrtfcYn: childCrtfcYn,
      prdtShapCdNm: prdtShapCdNm,
      frmlcMtrqlt: frmlcMtrqlt,
      indutyCdNm: indutyCdNm,
      lastUpdtDtm: lastUpdtDtm,
      indivRawmtrlNm: indivRawmtrlNm,
      etcRawmtrlNm: etcRawmtrlNm,
      capRawmtrlNm: capRawmtrlNm,
      frmlcMthd: frmlcMthd,
    );
  }
}
