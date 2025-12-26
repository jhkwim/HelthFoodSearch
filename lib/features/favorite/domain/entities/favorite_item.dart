import 'package:equatable/equatable.dart';

/// 즐겨찾기 엔티티
class FavoriteItem extends Equatable {
  final String reportNo;
  final String prdlstNm;
  final DateTime addedAt;

  const FavoriteItem({
    required this.reportNo,
    required this.prdlstNm,
    required this.addedAt,
  });

  @override
  List<Object?> get props => [reportNo, prdlstNm, addedAt];
}
