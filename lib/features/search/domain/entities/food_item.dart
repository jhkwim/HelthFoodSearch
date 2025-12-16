import 'package:equatable/equatable.dart';

class FoodItem extends Equatable {
  final String reportNo; // 품목제조신고번호 (Unique ID)
  final String prdlstNm; // 품목명
  final String rawmtrlNm; // 원재료 (Raw String)
  final List<String> mainIngredients; // 정제된 주원료 리스트
  final String bsshNm; // 업소명
  final String prmsDt; // 허가일자

  const FoodItem({
    required this.reportNo,
    required this.prdlstNm,
    required this.rawmtrlNm,
    required this.mainIngredients,
    required this.bsshNm,
    required this.prmsDt,
  });

  @override
  List<Object?> get props => [reportNo, prdlstNm, rawmtrlNm, mainIngredients, bsshNm, prmsDt];
}
