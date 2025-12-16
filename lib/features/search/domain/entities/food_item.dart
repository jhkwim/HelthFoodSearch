import 'package:equatable/equatable.dart';

class FoodItem extends Equatable {
  final String reportNo; // 품목제조신고번호 (Unique ID)
  final String prdlstNm; // 품목명
  final String rawmtrlNm; // 원재료 (Raw String)
  final List<String> mainIngredients; // 정제된 주원료 리스트
  final String bsshNm; // 업소명
  final String prmsDt; // 허가일자

  final String primaryFnclty; // 주된기능성
  final String iftknAtntMatrCn; // 섭취시주의사항
  final String ntkMthd; // 섭취방법
  final String cstdyMthd; // 보관방법
  final String pogDaycnt; // 유통기한
  final String dispos; // 성상
  
  final String lcnsNo; // 인허가번호
  final String prdlstCdnm; // 유형
  final String stdrStnd; // 기준규격
  final String hiengLntrtDvsNm; // 고열량저영양여부
  final String production; // 생산종료여부
  final String childCrtfcYn; // 어린이기호식품품질인증여부
  final String prdtShapCdNm; // 제품형태코드명
  final String frmlcMtrqlt; // 포장재질
  final String indutyCdNm; // 업종
  final String lastUpdtDtm; // 최종수정일자
  final String indivRawmtrlNm; // 기능성 원재료
  final String etcRawmtrlNm; // 기타 원재료
  final String capRawmtrlNm; // 캡슐 원재료
  final String frmlcMthd; // 포장방법

  const FoodItem({
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

  @override
  List<Object?> get props => [
        reportNo,
        prdlstNm,
        rawmtrlNm,
        mainIngredients,
        bsshNm,
        prmsDt,
        primaryFnclty,
        iftknAtntMatrCn,
        ntkMthd,
        cstdyMthd,
        pogDaycnt,
        dispos,
        lcnsNo,
        prdlstCdnm,
        stdrStnd,
        hiengLntrtDvsNm,
        production,
        childCrtfcYn,
        prdtShapCdNm,
        frmlcMtrqlt,
        indutyCdNm,
        lastUpdtDtm,
        indivRawmtrlNm,
        etcRawmtrlNm,
        capRawmtrlNm,
        frmlcMthd,
      ];
}
