import 'package:hive/hive.dart';
import '../../domain/entities/food_item.dart';

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
  @HiveField(6, defaultValue: '')
  final String primaryFnclty;
  @HiveField(7, defaultValue: '')
  final String iftknAtntMatrCn;
  @HiveField(8, defaultValue: '')
  final String ntkMthd;
  @HiveField(9, defaultValue: '')
  final String cstdyMthd;
  @HiveField(10, defaultValue: '')
  final String pogDaycnt;
  @HiveField(11, defaultValue: '')
  final String dispos;

  @HiveField(12, defaultValue: '')
  final String lcnsNo;
  @HiveField(13, defaultValue: '')
  final String prdlstCdnm;
  @HiveField(14, defaultValue: '')
  final String stdrStnd;
  @HiveField(15, defaultValue: '')
  final String hiengLntrtDvsNm;
  @HiveField(16, defaultValue: '')
  final String production;
  @HiveField(17, defaultValue: '')
  final String childCrtfcYn;
  @HiveField(18, defaultValue: '')
  final String prdtShapCdNm;
  @HiveField(19, defaultValue: '')
  final String frmlcMtrqlt;
  @HiveField(20, defaultValue: '')
  final String indutyCdNm;
  @HiveField(21, defaultValue: '')
  final String lastUpdtDtm;
  @HiveField(22, defaultValue: '')
  final String indivRawmtrlNm;
  @HiveField(23, defaultValue: '')
  final String etcRawmtrlNm;
  @HiveField(24, defaultValue: '')
  final String capRawmtrlNm;
  @HiveField(25, defaultValue: '')
  final String frmlcMthd;

  FoodItemHiveModel({
    required this.reportNo,
    required this.prdlstNm,
    required this.rawmtrlNm,
    required this.mainIngredients,
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

  factory FoodItemHiveModel.fromEntity(FoodItem item) {
    return FoodItemHiveModel(
      reportNo: item.reportNo,
      prdlstNm: item.prdlstNm,
      rawmtrlNm: item.rawmtrlNm,
      mainIngredients: item.mainIngredients,
      bsshNm: item.bsshNm,
      prmsDt: item.prmsDt,
      primaryFnclty: item.primaryFnclty,
      iftknAtntMatrCn: item.iftknAtntMatrCn,
      ntkMthd: item.ntkMthd,
      cstdyMthd: item.cstdyMthd,
      pogDaycnt: item.pogDaycnt,
      dispos: item.dispos,
      lcnsNo: item.lcnsNo,
      prdlstCdnm: item.prdlstCdnm,
      stdrStnd: item.stdrStnd,
      hiengLntrtDvsNm: item.hiengLntrtDvsNm,
      production: item.production,
      childCrtfcYn: item.childCrtfcYn,
      prdtShapCdNm: item.prdtShapCdNm,
      frmlcMtrqlt: item.frmlcMtrqlt,
      indutyCdNm: item.indutyCdNm,
      lastUpdtDtm: item.lastUpdtDtm,
      indivRawmtrlNm: item.indivRawmtrlNm,
      etcRawmtrlNm: item.etcRawmtrlNm,
      capRawmtrlNm: item.capRawmtrlNm,
      frmlcMthd: item.frmlcMthd,
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
