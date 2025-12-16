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
      primaryFnclty: json['PRIMARY_FNCLTY'] as String? ?? '',
      iftknAtntMatrCn: json['IFTKN_ATNT_MATR_CN'] as String? ?? '',
      ntkMthd: json['NTK_MTHD'] as String? ?? '',
      cstdyMthd: json['CSTDY_MTHD'] as String? ?? '',
      pogDaycnt: json['POG_DAYCNT'] as String? ?? '',
      dispos: json['DISPOS'] as String? ?? '',
      lcnsNo: json['LCNS_NO'] as String? ?? '',
      prdlstCdnm: json['PRDLST_CDNM'] as String? ?? '',
      stdrStnd: json['STDR_STND'] as String? ?? '',
      hiengLntrtDvsNm: json['HIENG_LNTRT_DVS_NM'] as String? ?? '',
      production: json['PRODUCTION'] as String? ?? '',
      childCrtfcYn: json['CHILD_CRTFC_YN'] as String? ?? '',
      prdtShapCdNm: json['PRDT_SHAP_CD_NM'] as String? ?? '',
      frmlcMtrqlt: json['FRMLC_MTRQLT'] as String? ?? '',
      indutyCdNm: json['INDUTY_CD_NM'] as String? ?? '',
      lastUpdtDtm: json['LAST_UPDT_DTM'] as String? ?? '',
      indivRawmtrlNm: json['INDIV_RAWMTRL_NM'] as String? ?? '',
      etcRawmtrlNm: json['ETC_RAWMTRL_NM'] as String? ?? '',
      capRawmtrlNm: json['CAP_RAWMTRL_NM'] as String? ?? '',
      frmlcMthd: json['FRMLC_MTHD'] as String? ?? '',
    );

Map<String, dynamic> _$FoodItemDtoToJson(FoodItemDto instance) =>
    <String, dynamic>{
      'PRDLST_REPORT_NO': instance.reportNo,
      'PRDLST_NM': instance.prdlstNm,
      'RAWMTRL_NM': instance.rawmtrlNm,
      'BSSH_NM': instance.bsshNm,
      'PRMS_DT': instance.prmsDt,
      'PRIMARY_FNCLTY': instance.primaryFnclty,
      'IFTKN_ATNT_MATR_CN': instance.iftknAtntMatrCn,
      'NTK_MTHD': instance.ntkMthd,
      'CSTDY_MTHD': instance.cstdyMthd,
      'POG_DAYCNT': instance.pogDaycnt,
      'DISPOS': instance.dispos,
      'LCNS_NO': instance.lcnsNo,
      'PRDLST_CDNM': instance.prdlstCdnm,
      'STDR_STND': instance.stdrStnd,
      'HIENG_LNTRT_DVS_NM': instance.hiengLntrtDvsNm,
      'PRODUCTION': instance.production,
      'CHILD_CRTFC_YN': instance.childCrtfcYn,
      'PRDT_SHAP_CD_NM': instance.prdtShapCdNm,
      'FRMLC_MTRQLT': instance.frmlcMtrqlt,
      'INDUTY_CD_NM': instance.indutyCdNm,
      'LAST_UPDT_DTM': instance.lastUpdtDtm,
      'INDIV_RAWMTRL_NM': instance.indivRawmtrlNm,
      'ETC_RAWMTRL_NM': instance.etcRawmtrlNm,
      'CAP_RAWMTRL_NM': instance.capRawmtrlNm,
      'FRMLC_MTHD': instance.frmlcMthd,
    };
