import 'package:equatable/equatable.dart';

/// 검색 히스토리 엔티티
class SearchHistory extends Equatable {
  final String query;
  final String type; // 'product' | 'ingredient'
  final DateTime searchedAt;

  const SearchHistory({
    required this.query,
    required this.type,
    required this.searchedAt,
  });

  @override
  List<Object?> get props => [query, type, searchedAt];
}
